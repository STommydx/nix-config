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
  };

  programs.codex = {
    enable = true;
    package = null;

    settings = {
      model_providers.z_ai = {
        name = "z.ai - GLM Coding Plan";
        base_url = "https://api.z.ai/api/coding/paas/v4";
        env_key = "Z_AI_API_KEY";
      };

      model = "GLM-4.7";
      model_provider = "z_ai";
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
