{ config, pkgs, ... }:

{
  imports = [
    ./hardware-pc.nix
    ./common.nix
  ];

  networking.hostName = "nixos-pc";
}
