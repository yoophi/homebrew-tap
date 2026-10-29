class Autosrt < Formula
  desc "Generate SRT subtitles from YouTube or local media with a terminal UI"
  homepage "https://github.com/yoophi/autosrt"
  url "https://github.com/yoophi/autosrt/releases/download/v2026.10.1/autosrt-2026.10.1-aarch64-apple-darwin.tar.gz"
  version "2026.10.1"
  sha256 "22bc8f30c09a3325631ed861b0d318203d43e2826826592641cd61dd210080f8"
  license "MIT"

  depends_on arch: :arm64
  depends_on macos: :sequoia
  depends_on "ffmpeg"
  depends_on "whisper.cpp"
  depends_on "yt-dlp"

  def install
    bin.install "autosrt"
    doc.install "README.md"
  end

  def caveats
    <<~EOS
      Configure a whisper.cpp GGML model before transcribing:
        autosrt config set model /path/to/ggml-small.bin
        autosrt doctor

      To copy legacy ystt settings and its model safely:
        autosrt config migrate
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autosrt --version")
    ENV["AUTOSRT_CONFIG_DIR"] = (testpath/"config").to_s
    system bin/"autosrt", "config", "set", "lang", "ko"
    assert_equal "ko", shell_output("#{bin}/autosrt config get lang").strip
  end
end
