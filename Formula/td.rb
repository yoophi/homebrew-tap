class Td < Formula
  desc "Task management CLI with SQLite and GitHub Issues storage"
  homepage "https://github.com/yoophi/td"
  # td-release-start
  # Stable source is populated after the first published yoophi/td release.
  # td-release-end
  license "MIT"
  head "https://github.com/yoophi/td.git", branch: "main"

  depends_on "go" => :build
  depends_on "gh"

  def install
    build_version = build.head? ? "dev" : version.to_s
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{build_version}"), "."
  end

  test do
    assert_match "td version", shell_output("#{bin}/td --version")
  end
end
