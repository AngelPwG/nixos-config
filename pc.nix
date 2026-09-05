{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # El hardware scan específico de tu PC
    ./common.nix                 # Tu configuración global
  ];

  networking.hostName = "nixos-pc"; # Recomendado: ponle un nombre distinto a la laptop
}
