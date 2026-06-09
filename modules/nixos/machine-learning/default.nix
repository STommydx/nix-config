{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    amdgpu_top
    rocmPackages.rocminfo
    lmstudio
  ];

  # Add rule for using rocm in deep learning libraries
  # https://nixos.wiki/wiki/AMD_GPU
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

}
