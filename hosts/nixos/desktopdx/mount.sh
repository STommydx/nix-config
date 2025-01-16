#!/usr/bin/env bash
sudo mount -o subvol=@,compress=zstd:1 /dev/disk/by-uuid/bb6013b6-26ce-46f9-a05b-9c9ec8b11cdd /mnt
sudo mount -o subvol=@data,compress=zstd:1 /dev/disk/by-uuid/bb6013b6-26ce-46f9-a05b-9c9ec8b11cdd /mnt/data
sudo mount -o subvol=@home,compress=zstd:1 /dev/disk/by-uuid/bb6013b6-26ce-46f9-a05b-9c9ec8b11cdd /mnt/home
sudo mount -o subvol=@nix,compress=zstd:1,noatime /dev/disk/by-uuid/bb6013b6-26ce-46f9-a05b-9c9ec8b11cdd /mnt/nix
sudo mount /dev/disk/by-uuid/916E-9B95 /mnt/boot
