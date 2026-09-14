class Agentmeter < Formula
  desc "Monitor coding-agent usage limits from one CLI"
  homepage "https://github.com/yoophi/agentmeter"
  url "https://github.com/yoophi/agentmeter/archive/refs/tags/2026.9.2.tar.gz"
  sha256 "66ed7c4bd32ca4b9153e9b3ef6bb0f1990966053e4b09261bb227a3878c237c6"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentmeter --version")
  end
end
