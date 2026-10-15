# Homebrew tap

Homebrew formulae for projects maintained by [yoophi](https://github.com/yoophi).

## td

The [yoophi/td fork](https://github.com/yoophi/td), built from source, with `gh`
installed as a runtime dependency for GitHub Issues storage.

Before the first stable fork release, the formula is HEAD-only:

```bash
brew install --HEAD yoophi/tap/td
```

HEAD builds use the fork's `main` branch. Merge the desired changes there before
installing. After the first published `vX.Y.Z` release has been picked up:

```bash
brew install yoophi/tap/td
brew update && brew upgrade yoophi/tap/td
```

If another tap's `td` is already installed, uninstall that formula before
installing this one; both provide the `td` executable. This does not require
deleting project `.todos` directories.

The **Update td formula** workflow checks published stable `yoophi/td` releases
hourly (GitHub schedules are best-effort) and can also be run manually:

```bash
gh workflow run update-td.yml --repo yoophi/homebrew-tap -f version=vX.Y.Z
```

It computes the source archive SHA256, updates only `Formula/td.rb`, and commits
as `yoophi <yoophi@gmail.com>`. It uses this tap's built-in Actions token; no
cross-repository personal token is required. Inherited upstream tags, drafts and
prereleases do not become stable formula releases. No release is a successful
no-op; invalid releases, downloads or formula markers fail without changing the
formula. Automatic updates do not downgrade the installed formula version.

Local validation (Python 3.11+):

```bash
python3 -m unittest discover -s scripts -p 'test_*.py'
python3 scripts/update_td.py --dry-run
ruby -c Formula/td.rb
```

## td-gui

A local web UI for td, distributed as prebuilt binaries for macOS and Linux
(Apple Silicon/ARM64 and Intel/AMD64).

```bash
brew install yoophi/tap/td-gui
```

Requires `td` v0.57.0 or newer on PATH. If needed, install this tap's td fork:

```bash
brew install --HEAD yoophi/tap/td
```

Run `td-gui` inside an existing td project (`td init` must have been run first).
It starts the local server and opens your browser.

```bash
brew update && brew upgrade yoophi/tap/td-gui
```

## td-backend

The Go and SQLite HTTP store for `td`. Releases follow `YYYY.M.PATCH` CalVer.

```bash
brew install yoophi/tap/td-backend
export TD_BACKEND_BOOTSTRAP_TOKEN="$(openssl rand -hex 32)"
td-backend --addr 127.0.0.1:7000 --db "$HOME/td-backend.db"
```

Keep the bootstrap token for restarts. `td` connects with
`TD_BACKEND_TOKEN="$TD_BACKEND_BOOTSTRAP_TOKEN"` and
`td init --store=td-backend,http://localhost:7000`.

```bash
brew update && brew upgrade yoophi/tap/td-backend
```

## agentmeter

```bash
brew install yoophi/tap/agentmeter
```

Upgrade with:

```bash
brew upgrade agentmeter
```

## diskmeter

Disk usage history (24h / 7d / 30d / 1y) in the terminal, a browser or a Hammerspoon panel.

```bash
brew install yoophi/tap/diskmeter
```

Upgrade with:

```bash
brew upgrade diskmeter
```
