{ pkgs, ... }:
let
  inherit (builtins) fetchTarball;
in
{
  pinPackage =
    {
      name,
      commit,
      sha256,
    }:
    (import (fetchTarball {
      inherit sha256;
      url = "https://github.com/NixOS/nixpkgs/archive/${commit}.tar.gz";
    }) { system = pkgs.system; }).${name};
}
