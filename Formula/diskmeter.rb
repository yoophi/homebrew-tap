class Diskmeter < Formula
  desc "Record disk usage history and chart it in the terminal, browser or Hammerspoon"
  homepage "https://github.com/yoophi/diskmeter"
  url "https://github.com/yoophi/diskmeter/archive/refs/tags/2026.10.1.tar.gz"
  sha256 "7bcc5b80426fc21395a9f89cc22999d8ce83cfcd63662e70534b3f651d3dc7e9"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diskmeter --version")
  end
end
