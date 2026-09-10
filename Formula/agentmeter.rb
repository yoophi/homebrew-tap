class Agentmeter < Formula
  desc "Monitor coding-agent usage limits from one CLI"
  homepage "https://github.com/yoophi/agentmeter"
  url "https://github.com/yoophi/agentmeter/archive/refs/tags/2026.9.1.tar.gz"
  sha256 "1691a6c29a420634148458cd92ab774e5761fb5eaf1a63e5e63472fea9c86e0d"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentmeter --version")
  end
end
