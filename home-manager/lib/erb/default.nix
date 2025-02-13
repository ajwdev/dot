pkgs: template: pname: attrs:
let
  map = pkgs.lib.mapAttrsToList;
  join = pkgs.lib.intersperse " ";
in
derivation {
  name = "erb-${pname}";
  builder = "${pkgs.bash}/bin/bash";
  args = [ ./erb.sh ];
  buildInputs = with pkgs; [
    bash
    ruby
  ];
  system = pkgs.system;
  # Extras for the script
  vars = join (map (k: v: "${k}=${v}") attrs);
  inherit template;
}
