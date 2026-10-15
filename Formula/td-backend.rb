class TdBackend < Formula
  desc "Go HTTP backend for the td issue tracker with SQLite and PostgreSQL"
  homepage "https://github.com/yoophi/td-backend"
  url "https://github.com/yoophi/td-backend/archive/refs/tags/2026.10.1.tar.gz"
  sha256 "81636c05a0cba9dc6f432979bdf5891a02aa7e5e9b0e95c0adcd8602cf48e956"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/td-backend"
  end

  test do
    ENV.delete "TD_BACKEND_BOOTSTRAP_TOKEN"
    ENV.delete "TD_BACKEND_DATABASE_URL"
    database = testpath/"test.db"
    assert_match "TD_BACKEND_BOOTSTRAP_TOKEN must contain at least 32 characters",
                 shell_output("#{bin}/td-backend --db #{database} 2>&1", 1)
    refute database.exist?

    ENV["TD_BACKEND_BOOTSTRAP_TOKEN"] = "0123456789abcdef0123456789abcdef"
    assert_match "postgres requires TD_BACKEND_DATABASE_URL",
                 shell_output("#{bin}/td-backend --db-engine=postgres 2>&1", 1)
  end
end
