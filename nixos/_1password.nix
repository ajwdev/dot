{ inputs, pkgs, ... }:
{
  disabledModules = [ 
    "programs/_1password.nix"
    "programs/_1password-gui.nix"
  ];

  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/programs/_1password.nix"
    "${inputs.nixpkgs-unstable}/nixos/modules/programs/_1password-gui.nix"
  ];

  programs._1password = {
    enable = true;
    package = pkgs.unstable._1password-cli;
  };
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "andrew" ];
    package = pkgs.unstable._1password-gui;
  };
}
