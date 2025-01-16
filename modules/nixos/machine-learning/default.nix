{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    amdgpu_top
    rocmPackages.rocminfo
  ];

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.0"; # TODO: make this configurable via options
  };

  # Add rule for using rocm in deep learning libraries
  # https://nixos.wiki/wiki/AMD_GPU
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

}
