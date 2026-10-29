class Autosrt < Formula
  desc "Generate SRT subtitles from YouTube or local media with a terminal UI"
  homepage "https://github.com/yoophi/autosrt"
  url "https://github.com/yoophi/autosrt/releases/download/v2026.10.2/autosrt-2026.10.2-aarch64-apple-darwin.tar.gz"
  version "2026.10.2"
  sha256 "c2df12f0c358af9f09cce1fb974b0719dd2f848ddb6dd0806962976ab1505267"
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
      YouTube uses automatic captions first unless a mode is saved or specified.
      To keep transcription-only behavior:
        autosrt config set subtitle-mode transcribe-only

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
    system bin/"autosrt", "config", "set", "subtitle-mode", "both"
    assert_equal "both", shell_output("#{bin}/autosrt config get subtitle-mode").strip
    assert_match "--subtitle-mode", shell_output("#{bin}/autosrt --help")
  end
end
