{ config, pkgs, ... }:

{
  imports = [
    ./hardware-pc.nix
    ./common.nix
  ];

  fileSystems."/mnt/extdisk" = {
    device = "/dev/disk/by-uuid/ef729637-bfa4-4b1d-8159-95d22dcf5aa3";
    fsType = "ext4";

    options = [
      "nofail"
      "x-systemd.automount"
    ];
  };

  networking.hostName = "nixos-pc";
}
