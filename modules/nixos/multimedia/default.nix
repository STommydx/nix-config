{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    blender
    ffmpeg
    inkscape
    pandoc
    pinta
    spotify
    xournalpp
    yt-dlp
  ];
}
