{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    blender
    ffmpeg
    inkscape
    pandoc
    pinta
    spotify
    # xournalpp # disabled temporarily due to build failure
    yt-dlp
  ];
}
