class Sand < Formula
  desc "Multi-backend workspace manager for developers (Zellij/tmux/Ghostty)"
  homepage "https://github.com/arsis-dev/sand"
  url "https://github.com/arsis-dev/sand/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "bb3f949c8ec49977d436c8145970d6a2cfb354d64199f5736f3dbf6a0756b6c6"
  license "MIT"

  depends_on :macos
  depends_on "zellij" => :recommended
  depends_on "tmux" => :optional
  depends_on "python@3.13" => :recommended
  depends_on "terminal-notifier" => :recommended

  def install
    # Everything goes into libexec (private, not symlinked by Homebrew)
    libexec.install "bin/sand"
    libexec.install "bin/sand-workspace-helper"
    libexec.install "layouts"
    libexec.install "notify"

    # Wrapper scripts in bin/ (these get symlinked to HOMEBREW_PREFIX/bin)
    (bin/"sand").write_env_script libexec/"sand", SAND_LIBEXEC: libexec
    (bin/"sand-workspace-helper").write_env_script libexec/"sand-workspace-helper",
                                                   SAND_LIBEXEC: libexec
    (bin/"sand-notify").write_env_script libexec/"notify/notify.sh",
                                        SAND_LIBEXEC: libexec
  end

  def caveats
    <<~EOS
      Recommended TUI apps for panels:
        brew install lazygit yazi fzf btop

      Workspace configs: ~/.config/sand/workspaces/
      Run 'sand workspace new' to create your first workspace.
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/sand --help 2>&1")
  end
end
