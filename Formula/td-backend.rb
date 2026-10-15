class TdBackend < Formula
  desc "Go and SQLite HTTP backend for the td issue tracker"
  homepage "https://github.com/yoophi/td-backend"
  url "https://github.com/yoophi/td-backend/archive/refs/tags/2026.10.0.tar.gz"
  sha256 "2729bc92523f5e2126e784aa1982286d183154e8171ce58ca82d5152a24ebb74"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/td-backend"
  end

  test do
    ENV.delete "TD_BACKEND_BOOTSTRAP_TOKEN"
    database = testpath/"test.db"
    assert_match "TD_BACKEND_BOOTSTRAP_TOKEN must contain at least 32 characters",
                 shell_output("#{bin}/td-backend --db #{database} 2>&1", 1)
    refute database.exist?
  end
end
