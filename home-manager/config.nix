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

    ssh = {
      hosts = mkOption {
        type = types.lines;
        default = "";
        description = "Additional SSH host configurations";
        example = ''
          Host work-server
              HostName server.company.com
              User myuser
        '';
      };
    };

    git = {
      config = mkOption {
        type = types.lines;
        default = "";
        description = "Additional git configuration";
        example = ''
          [user]
              email = work@company.com
        '';
      };
    };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Environment variables for templates";
      example = {
        WORK_USER = "john.doe";
        COMPANY_URL = "https://company.com";
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
