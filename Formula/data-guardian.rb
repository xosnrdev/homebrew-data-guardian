class DataGuardian < Formula
  desc "System utility that monitors the disk I/O usage of applications running on your computer"
  homepage "https://github.com/xosnrdev/data-guardian?tab=readme-ov-file"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xosnrdev/data-guardian/releases/download/v1.0.2/data-guardian-aarch64-apple-darwin.tar.xz"
      sha256 "3d0b59e14c8290068640a294964446030bf3d3531f87fc1f82991a0c6a26d247"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xosnrdev/data-guardian/releases/download/v1.0.2/data-guardian-x86_64-apple-darwin.tar.xz"
      sha256 "1a10287007d0bc359c9648477e5beb8b83503329d267d5ce8b811b5ac57d898b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/xosnrdev/data-guardian/releases/download/v1.0.2/data-guardian-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "525934f5a4fb9c4fb3d9a0799983f17266dbe2cf438fd60611e8d0d9aa22ab7d"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "dg" if OS.mac? && Hardware::CPU.arm?
    bin.install "dg" if OS.mac? && Hardware::CPU.intel?
    bin.install "dg" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
