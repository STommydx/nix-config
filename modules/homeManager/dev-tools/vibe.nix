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
    ANTHROPIC_DEFAULT_SONNET_MODEL = "GLM-4.7";
    ANTHROPIC_DEFAULT_OPUS_MODEL = "GLM-4.7";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "GLM-4.5-Air";
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
