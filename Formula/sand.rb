class Sand < Formula
  desc "Multi-backend workspace manager for developers (Zellij/tmux/Ghostty)"
  homepage "https://github.com/arsis-dev/sand"
  url "https://github.com/arsis-dev/sand/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "5fece225568f7caf44c0b41df97d22d6b3ea1f9117af649e91e260227faf4858"
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
