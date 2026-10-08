#!/usr/bin/env python3
"""Update td from a published fork release, using gh and a source tarball."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

REPO = "yoophi/td"
TAG = re.compile(r"v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)")
START = "  # td-release-start\n"
END = "  # td-release-end"
FORMULA = Path(__file__).resolve().parents[1] / "Formula" / "td.rb"


def version_tuple(tag):
    match = TAG.fullmatch(tag)
    if not match:
        raise ValueError(f"Expected a stable vX.Y.Z release tag, got {tag!r}")
    return tuple(map(int, match.groups()))


def release_tag(release):
    if release.get("draft") or release.get("prerelease") or not release.get("published_at"):
        return None
    tag = release.get("tag_name", "")
    return tag if TAG.fullmatch(tag) else None


def select_release(releases, requested=""):
    if requested:
        version_tuple(requested)
    tags = [tag for release in releases if (tag := release_tag(release))]
    if requested:
        if requested not in tags:
            raise ValueError(f"{requested} is not a published stable release of {REPO}")
        return requested
    return max(tags, key=version_tuple) if tags else None


def fetch_releases():
    result = subprocess.run(
        ["gh", "api", "--hostname", "github.com", f"repos/{REPO}/releases?per_page=100", "--paginate", "--slurp"],
        check=True, text=True, capture_output=True,
    )
    return [release for page in json.loads(result.stdout) for release in page]


def source_sha(url):
    with tempfile.TemporaryDirectory(prefix="td-source-") as directory:
        archive = Path(directory) / "source.tar.gz"
        subprocess.run(["curl", "--fail", "--silent", "--show-error", "--location", "--retry", "3",
                        "--max-time", "120", "--output", str(archive), url], check=True)
        with archive.open("rb") as stream:
            return hashlib.file_digest(stream, "sha256").hexdigest()


def current_tag(formula):
    match = re.search(r'url "https://github.com/yoophi/td/archive/refs/tags/([^"/]+)\.tar\.gz"', formula)
    return match.group(1) if match else None


def render_formula(formula, tag, sha):
    version_tuple(tag)
    if not re.fullmatch(r"[a-f0-9]{64}", sha):
        raise ValueError("Invalid source SHA256")
    if formula.count(START) != 1 or formula.count(END) != 1:
        raise ValueError("Formula must contain exactly one td release block")
    before, rest = formula.split(START)
    _, after = rest.split(END)
    url = f"https://github.com/{REPO}/archive/refs/tags/{tag}.tar.gz"
    return before + START + f'  url "{url}"\n  sha256 "{sha}"\n' + END + after


def report(changed, tag=""):
    output = os.environ.get("GITHUB_OUTPUT")
    if output:
        with open(output, "a", encoding="utf-8") as stream:
            stream.write(f"changed={str(changed).lower()}\nversion={tag}\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--version", default="", help="Published stable tag; default: highest stable release")
    parser.add_argument("--dry-run", action="store_true", help="Download and verify source without changing the formula")
    args = parser.parse_args()
    if args.version:
        version_tuple(args.version)
    tag = select_release(fetch_releases(), args.version)
    if tag is None:
        print(f"No published stable releases in {REPO}; keeping HEAD-only formula.")
        report(False)
        return
    formula = FORMULA.read_text()
    current = current_tag(formula)
    if current and version_tuple(tag) < version_tuple(current):
        raise ValueError(f"Refusing to downgrade {current} to {tag}")
    if current == tag:
        print(f"td is already at {tag}.")
        report(False, tag)
        return
    url = f"https://github.com/{REPO}/archive/refs/tags/{tag}.tar.gz"
    sha = source_sha(url)
    updated = render_formula(formula, tag, sha)
    print(f"td {tag}: {url} (sha256: {sha})")
    if args.dry_run:
        report(False, tag)
        return
    temporary = FORMULA.with_suffix(".rb.tmp")
    temporary.write_text(updated)
    temporary.replace(FORMULA)
    report(True, tag)


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        raise SystemExit(f"td formula update failed: {error}") from error
