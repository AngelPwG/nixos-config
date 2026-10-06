{ config, inputs, lib, pkgs, ... }:
let
  expectedRevision = "ebdd9042b0d589c853e06964adccc535c35ff463";
  patchedAssets = pkgs.runCommand "jes-bar-cpu-ram-mpris" {
    nativeBuildInputs = [ pkgs.python3 ];
  } ''
    mkdir -p "$out"
    cp -r ${inputs.jes}/.local/JES/. "$out/"
    chmod -R u+w "$out"
    python3 ${./jes-bar-fix/patch.py} "$out/quickshell" ${pkgs.python3}/bin/python3
    cp ${./jes-bar-fix/system-stats.py} "$out/quickshell/scripts/system-stats.py"
  '';
in {
  assertions = [{
    assertion = (inputs.jes.rev or "") == expectedRevision;
    message = "jes-bar-fix is for JES ebdd904 only. Remove or port this module before updating the jes input.";
  }];

  # The original JES activation runs first. Then use the patched assets.
  system.activationScripts.installJesFiles.text = lib.mkAfter ''
    for jesUser in ${lib.concatStringsSep " " config.services.jes.users}; do
      jesHome="/home/$jesUser"
      if [ -d "$jesHome" ]; then
        ln -sfn ${patchedAssets} "$jesHome/.local/JES"
        chown -h "$jesUser":users "$jesHome/.local/JES"
      fi
    done
  '';
}
