{ pkgs, ... }:

{
  # vibe coding tools
  environment.systemPackages = with pkgs; [
    claude-code
    codex
    crush
    gemini-cli
  ];
}
