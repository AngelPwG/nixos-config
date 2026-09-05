{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  nixpkgs.config.allowUnfree = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
   enable = true;
   enable32Bit = true;
  };

  networking.networkmanager.enable = true;
  time.timeZone = "America/Mazatlan";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha-mauve";
  };

  services.flatpak.enable = true;
  services.tailscale.enable = true;

  services.xserver.xkb = {
    layout = "latam";
    variant = "nodeadkeys";
  };
  console.keyMap = "la-latin1";

  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."angelpwg" = {
    isNormalUser = true;
    description = "AngelPwG";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs.sway.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  
  services.xserver.wacom.enable = true;
  security.polkit.enable = true;
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    neovim git wl-clipboard alacritty
    zellij gnumake cargo wget
    (catppuccin-sddm.override {
      flavor = "mocha";
      background = "${./dotfiles/sway/bg.jpg}";
    })
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  system.stateVersion = "26.05";
  home-manager.users.angelpwg = import ./home.nix;
}
