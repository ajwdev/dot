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

    # Extensible - work configs can add new sections
    work = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Work-specific configuration sections";
    };
  };
}
