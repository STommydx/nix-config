{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    amdgpu_top
    rocmPackages.rocminfo
    lmstudio
  ];

  environment.variables = {
    HSA_OVERRIDE_GFX_VERSION = "11.0.0";
  };

  # Add rule for using rocm in deep learning libraries
  # https://nixos.wiki/wiki/AMD_GPU
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

}
