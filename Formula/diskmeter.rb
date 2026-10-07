class Diskmeter < Formula
  desc "Record disk usage history and chart it in the terminal, browser or Hammerspoon"
  homepage "https://github.com/yoophi/diskmeter"
  url "https://github.com/yoophi/diskmeter/archive/refs/tags/2026.10.2.tar.gz"
  sha256 "e381b8f99eae0713e7fbec038d127ae5bf442a8962922954c215b6d5b356f46f"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diskmeter --version")
  end
end
