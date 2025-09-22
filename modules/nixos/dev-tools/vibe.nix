{ pkgs, ... }:

{
  # vibe coding tools
  environment.systemPackages = with pkgs; [
    claude-code
    crush
    gemini-cli
  ];
}
