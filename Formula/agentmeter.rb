class Agentmeter < Formula
  desc "Monitor coding-agent usage limits from one CLI"
  homepage "https://github.com/yoophi/agentmeter"
  url "https://github.com/yoophi/agentmeter/archive/refs/tags/2026.9.5.tar.gz"
  sha256 "f9e82a680fec587d4dad9d9ac58f9dfd813ae7622b3388bd86ab499a01ad70b4"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentmeter --version")
  end
end
