{
  config,
  ...
}:

{
  # settings for vibe coding tools
  home.sessionVariables = {
    # Claude Code with MiniMax
    # https://platform.minimax.io/docs/coding-plan/claude-code
    ANTHROPIC_BASE_URL = "https://api.minimax.io/anthropic";
    API_TIMEOUT_MS = "3000000";
    CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = 1;
    ANTHROPIC_MODEL = "MiniMax-M2.5";
    ANTHROPIC_SMALL_FAST_MODEL = "MiniMax-M2.5";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "MiniMax-M2.5";
    ANTHROPIC_DEFAULT_OPUS_MODEL = "MiniMax-M2.5";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "MiniMax-M2.5";
    CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude"; # https://github.com/anthropics/claude-code/issues/1455
    OPENCODE_ENABLE_EXA = 1;
  };

  programs.opencode = {
    enable = true;

    settings = {
      permission = {
        "*" = "ask";
        read = "allow";
        grep = "allow";
        glob = "allow";
        todoread = "allow";
        todowrite = "allow";
        bash = {
          "*" = "ask";
          ls = "allow";
          "ls *" = "allow";
          cat = "allow";
          "cat *" = "allow";
          head = "allow";
          "head *" = "allow";
          tail = "allow";
          "tail *" = "allow";
          file = "allow";
          "file *" = "allow";
          wc = "allow";
          "wc *" = "allow";
          pwd = "allow";
          which = "allow";
          "which *" = "allow";
          "git status" = "allow";
          "git log" = "allow";
          "git log *" = "allow";
          "git diff" = "allow";
          "git diff *" = "allow";
          "git show" = "allow";
          "git show *" = "allow";
        };
        "context7_*" = "allow";
      };

      agent.editor = {
        mode = "primary";
        permission.edit = "allow";
      };
    };
  };

  programs.git.ignores = [
    # LLM context files and memory, should be explicitly committed
    "CLAUDE.md"
    "CRUSH.md"
    "GEMINI.md"
    "QWEN.md"
  ];
}
