#!/usr/bin/env bash
sudo mount -o subvol=@,compress=zstd:1 /dev/disk/by-uuid/789831e1-88d3-4d0f-bf4b-3d9e2c3cad5c /mnt
sudo mount -o subvol=@home,compress=zstd:1 /dev/disk/by-uuid/789831e1-88d3-4d0f-bf4b-3d9e2c3cad5c /mnt/home
sudo mount -o subvol=@nix,compress=zstd:1,noatime /dev/disk/by-uuid/789831e1-88d3-4d0f-bf4b-3d9e2c3cad5c /mnt/nix
sudo mount /dev/disk/by-uuid/8652-458B /mnt/boot
