{ config, lib, nixosConfig, bloxpkgs, ... }: with lib;

let
  cfg = config.blox.features.workstation;
in {
  options.blox.features.workstation.compositor.enable = mkOption {
    description = "Whether to enable compositing.";
    default = !(hasAttr "vm" nixosConfig.system.build);  # Disable in VMs by default
    defaultText = "!nixosConfig.system.build.vm";
    type = types.bool;
  };

  config = mkIf (cfg.enable && cfg.compositor.enable) {
    home.packages = with bloxpkgs; [
      compton-tryone
    ];
    home.file.".config/compton.conf".source = ./compton.conf;
  };
}
