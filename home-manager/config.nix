{ lib, ... }:

{
  options.dotfiles = with lib; {
    user = {
      name = mkOption {
        type = types.str;
        default = "Andrew Williams";
        description = "Full name for git and other configs";
      };

      email = mkOption {
        type = types.str;
        default = "williams.andrew@gmail.com";
        description = "Email for git and other configs";
      };
    };

    work = {
      enable = mkEnableOption "work mode (skips dotfiles that conflict with managed work tooling)";
    };
  };
}
