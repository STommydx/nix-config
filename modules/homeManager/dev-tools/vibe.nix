{
  config,
  ...
}:

{
  # settings for vibe coding tools
  home.sessionVariables = {
    # Claude Code with Z.ai
    ANTHROPIC_BASE_URL = "https://api.z.ai/api/anthropic";
    ANTHROPIC_MODEL = "GLM-4.5";
    ANTHROPIC_SMALL_FAST_MODEL = "GLM-4.5-Air";
    CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude"; # https://github.com/anthropics/claude-code/issues/1455
  };
}
