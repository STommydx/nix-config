{ pkgs, ... }:

{
  # In-game HUD display
  programs.mangohud = {
    enable = true;
    settings = {
      gpu_stats = true;
      gpu_temp = true;
      gpu_load_change = true;
      cpu_stats = true;
      cpu_temp = true;
      cpu_load_change = true;
      core_load_change = true;
      vram = true;
      ram = true;
      fps = true;
      gamemode = true;
      no_display = true;
      position = "top-left";
      toggle_hud = "Shift_R+F12";
    };
  };

  # OBS Plugins
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      input-overlay # showing keypress on screen
      obs-pipewire-audio-capture # capture desktop audio
      obs-vkcapture # capture vulkan games natively
    ];
  };
}
