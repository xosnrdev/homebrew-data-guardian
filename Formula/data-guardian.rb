class DataGuardian < Formula
  desc "System service for monitoring and optimizing app data usage"
  homepage "https://github.com/xosnrdev/data-guardian?tab=readme-ov-file"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xosnrdev/data-guardian/releases/download/v1.0.1/data-guardian-aarch64-apple-darwin.tar.xz"
      sha256 "817668c2c1d2c2b137b1beb572781fca63619d000bb6fc964af24f6ee9c03502"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xosnrdev/data-guardian/releases/download/v1.0.1/data-guardian-x86_64-apple-darwin.tar.xz"
      sha256 "30585de215fabf2e9ce96ce1305e9e4c99f06cdf4d82b2f87017c4414c5fa98f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/xosnrdev/data-guardian/releases/download/v1.0.1/data-guardian-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "15d81f57ff308f0ef323d5cfdf3c631731e9b7a38de1f27e71bd831d2433ad63"
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
