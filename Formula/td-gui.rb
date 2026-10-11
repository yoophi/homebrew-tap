class TdGui < Formula
  desc "Local web UI for the td issue tracker"
  homepage "https://github.com/yoophi/td-gui"
  version "0.18.17"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/yoophi/td-gui/releases/download/v0.18.17/td-gui-v0.18.17-darwin-arm64.tar.gz"
      sha256 "00b88d0be736017af973a611f473e17a9efa7320be6fd96c3280b0df3cd726b8"
    end

    on_intel do
      url "https://github.com/yoophi/td-gui/releases/download/v0.18.17/td-gui-v0.18.17-darwin-amd64.tar.gz"
      sha256 "42f195add4e1cb35b9cecd80b74d2107b04220b8802b5698b72e7a7d2fca383d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yoophi/td-gui/releases/download/v0.18.17/td-gui-v0.18.17-linux-arm64.tar.gz"
      sha256 "755b4c3b01874b7a081c79a402ca677c05f9cffd4d6c6d00a46f50275230dfa2"
    end

    on_intel do
      url "https://github.com/yoophi/td-gui/releases/download/v0.18.17/td-gui-v0.18.17-linux-amd64.tar.gz"
      sha256 "b9839a32a64964c35828016ddaec9ea1540bc1bcf19ca7423c0168580c594d0f"
    end
  end

  def install
    bin.install "td-gui"
  end

  def caveats
    <<~EOS
      Requires td v0.57.0 or newer on PATH. To install the yoophi fork:
        brew install --HEAD yoophi/tap/td

      Run td-gui inside a project that has already been initialized with td init.
    EOS
  end

  test do
    assert_match "td-gui v#{version}", shell_output("#{bin}/td-gui --version")
  end
end
