{ pkgs }:

{
  pinPackage =
    {
      name,
      commit,
      sha256,
    }:
    (import (builtins.fetchTarball {
      inherit sha256;
      url = "https://github.com/NixOS/nixpkgs/archive/${commit}.tar.gz";
    }) { system = pkgs.system; }).${name};
}
