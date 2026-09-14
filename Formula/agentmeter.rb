class Agentmeter < Formula
  desc "Monitor coding-agent usage limits from one CLI"
  homepage "https://github.com/yoophi/agentmeter"
  url "https://github.com/yoophi/agentmeter/archive/refs/tags/2026.9.3.tar.gz"
  sha256 "b749a3dcd9fe784e806726029732a50649011fb66f201747a44c40e23b516f65"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentmeter --version")
  end
end
