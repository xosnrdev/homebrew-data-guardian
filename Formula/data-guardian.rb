class DataGuardian < Formula
  desc "System service for monitoring and optimizing app data usage"
  homepage "https://github.com/xosnrdev/data-guardian?tab=readme-ov-file"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xosnrdev/data-guardian/releases/download/v1.0.0/data-guardian-aarch64-apple-darwin.tar.xz"
      sha256 "cd5ca622056dcebd4b0311c5d39318ce8ca75445c7468abfb12605357a32b106"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xosnrdev/data-guardian/releases/download/v1.0.0/data-guardian-x86_64-apple-darwin.tar.xz"
      sha256 "9a64fd058df6e6a2d7ea6f5b4a925e2ece58007b6faff297790e2e020e63bfb3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/xosnrdev/data-guardian/releases/download/v1.0.0/data-guardian-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7bb5b1b4c238c284b852ef97670421f540b959b8cd5cde2fe05e09b8ea86667b"
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
