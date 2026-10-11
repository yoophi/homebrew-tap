class Td < Formula
  desc "Task management CLI with SQLite and GitHub Issues storage"
  homepage "https://github.com/yoophi/td"
  # td-release-start
  url "https://github.com/yoophi/td/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "de0975bf8779b4b56c711499ac08a293930d9a78427beb068d77cecc799d5d23"
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
