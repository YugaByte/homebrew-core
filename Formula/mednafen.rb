class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.21.3.tar.xz"
  sha256 "2e761e8834b098b7f1ab35dccaa6d2be715ee9106cf40af4919f6ca4b99ee3c6"

  bottle do
    sha256 "d4e4e7db27ba03192573ffd25cc1001aa6fee082c125f0aed68aebf6c84068f3" => :high_sierra
    sha256 "ff2cdee178008a503e56b4ea5d607d4bee39360232c220eeda0f4fb572dbad92" => :sierra
    sha256 "814e63968eba05ebcc506ce257c695d4b46b70645f120c66bad9cd4449026e8c" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "libsndfile"
  depends_on :macos => :sierra # needs clock_gettime
  depends_on "gettext"

  unless OS.mac?
    depends_on "zlib"
    depends_on "linuxbrew/xorg/glu"
    depends_on "linuxbrew/xorg/mesa"
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j16" if ENV["CIRCLECI"]

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # Test fails on headless CI: Could not initialize SDL: No available video device
    return if ENV["CIRCLECI"] || ENV["TRAVIS"]
    cmd = "#{bin}/mednafen | head -n1 | grep -o '[0-9].*'"
    assert_equal version.to_s, shell_output(cmd).chomp
  end
end
