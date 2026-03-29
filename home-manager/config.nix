{ lib, ... }:

{
  options.dotfiles = with lib; {
    work = {
      enable = mkEnableOption "work mode (skips dotfiles that conflict with managed work tooling)";
    };
  };
}
