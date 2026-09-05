{ config, pkgs, ... }:

let
  kernel = config.boot.kernelPackages.kernel;

  aic8800-src = pkgs.fetchFromGitHub {
    owner = "shenmintao";
    repo = "aic8800d80";
    rev = "legacy-mcu1";
    hash = "sha256-H+DYThqJeNxYriGs3AhlFFUnEX9Tl6eKow01StOYdEs=";
  };
  
  aic8800-module = pkgs.stdenv.mkDerivation {
    name = "aic8800-module-${kernel.version}";
    src = aic8800-src;
    nativeBuildInputs = kernel.moduleBuildDependencies;
    sourceRoot = "source/drivers/aic8800";
    postPatch = ''
      find . -type f -name "*.c" -print0 | xargs -0 sed -E -i \
      -e 's/USB_DEVICE\(\s*0x[aA]69[cC]\s*,\s*0x8[dD]80\s*\)/& }, { USB_DEVICE(0x2604, 0x0013)/g' \
      -e 's/USB_DEVICE\(\s*0x[aA]69[cC]\s*,\s*0x8[dD]81\s*\)/& }, { USB_DEVICE(0x2604, 0x0013)/g' \
      -e 's/USB_DEVICE\(\s*0x368[bB]\s*,\s*0x8[dD]81\s*\)/& }, { USB_DEVICE(0x2604, 0x0013)/g'
    '';
    makeFlags = [
      "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "CONFIG_USE_FW_REQUEST=y"
    ];
    buildPhase = ''
      make -j$NIX_BUILD_CORES $makeFlags
    '';
    installPhase = ''
      mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/aic8800
      cp aic_load_fw/aic_load_fw.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/aic8800/
      cp aic8800_fdrv/aic8800_fdrv.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/aic8800/
    '';
  };

  aic8800-firmware = pkgs.stdenv.mkDerivation {
    name = "aic8800-firmware";
    src = aic8800-src;
    installPhase = ''
      mkdir -p $out/lib/firmware
      find fw -type f -exec cp {} $out/lib/firmware/ \;
    '';
  };
in
{
  imports = [
    ./hardware-laptop.nix
    ./common.nix
  ];

  networking.hostName = "nixos-laptop";

  boot.extraModulePackages = [ aic8800-module ];
  boot.kernelModules = [ "aic_load_fw" "aic8800_fdrv" ];
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="block", ATTRS{idVendor}=="a69c", ATTRS{idProduct}=="5721", RUN+="${pkgs.util-linux}/bin/eject /dev/%k"
  '';
  hardware.firmware = [ aic8800-firmware ];
  hardware.usb-modeswitch.enable = true;
}
