{
  config,
  ...
}:

{
  # settings for vibe coding tools
  home.sessionVariables = {
    # Claude Code with Z.ai
    # https://docs.z.ai/devpack/tool/claude
    ANTHROPIC_BASE_URL = "https://api.z.ai/api/anthropic";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "GLM-4.6";
    ANTHROPIC_DEFAULT_OPUS_MODEL = "GLM-4.6";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "GLM-4.5-Air";
    CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude"; # https://github.com/anthropics/claude-code/issues/1455
  };

  programs.git.ignores = [
    # LLM context files and memory, should be explicitly committed
    "CLAUDE.md"
    "CRUSH.md"
    "GEMINI.md"
    "QWEN.md"
  ];
}
