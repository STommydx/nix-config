{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    ffmpeg
    pandoc
    yt-dlp
  ];

  homebrew = {
    casks = [
      "spotify"
      "xournal++"
    ];
  };

}
