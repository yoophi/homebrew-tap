class Agentmeter < Formula
  desc "Monitor coding-agent usage limits from one CLI"
  homepage "https://github.com/yoophi/agentmeter"
  url "https://github.com/yoophi/agentmeter/archive/refs/tags/2026.8.2.tar.gz"
  sha256 "f8835760ad5f47dce2251116f742c3138f0e3fbe2e636ea33e6ea82bb3cb9890"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentmeter --version")
  end
end
