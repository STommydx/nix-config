{
  config,
  ...
}:

{
  # settings for vibe coding tools
  home.sessionVariables = {
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
