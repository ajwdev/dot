{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.devtools;
  isEnabled = lang: cfg.enable_all || lib.getAttr "enable" (lib.getAttr lang cfg);
in
{
  options.devtools = {
    enable_all = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable all dev tools";
    };

    go.enable = lib.mkEnableOption "Enable Go";
    rust.enable = lib.mkEnableOption "Enable Rust";
    ruby.enable = lib.mkEnableOption "Enable Ruby";
    # TODO
    # zig.enable = lib.mkEnableOption "Enable Zig";
    arduino.enable = lib.mkEnableOption "Enable Arduino tools+IDE";
  };

  config = {
    home.packages =
      with pkgs;
      [
        httpie
        gnumake
        gdb
        kind
      ]
      ++ lib.optionals (isEnabled "go") [
        go
        gopls
        go-tools
        # gomod2nix.packages.${system}.default
      ]
      ++ lib.optionals (isEnabled "rust") [ rustup ]
      ++ lib.optionals (isEnabled "arduino") [
        arduino-ide
        arduino-cli
      ];

    programs.rbenv.enable = isEnabled "ruby";
  };
}
