{ inputs, pkgs, ... }:
{

  programs._1password = {
    enable = true;
    package = pkgs._1password-cli;
  };
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "andrew" ];
    package = pkgs._1password-gui;
  };
}
