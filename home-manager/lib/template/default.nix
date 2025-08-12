{ pkgs, lib }:

rec {
  # Generic template function that automatically loads ALL attributes from config
  templateFile =
    {
      src,
      config ? { }, # Config attrset passed from flake (can be module config)
      buildTimeConfig ? { }, # Build-time variables (package paths, system info, etc.)
      name ? null,
    }:
    let
      # Automatically convert ALL config attributes to template variables
      # Recursively flatten nested attributes with underscore separation
      flattenConfig =
        prefix: attrs:
        lib.concatMapAttrs (
          key: value:
          let
            newKey = if prefix == "" then key else "${prefix}_${key}";
          in
          if lib.isAttrs value && !lib.isDerivation value then
            flattenConfig newKey value
          else
            { ${lib.toUpper newKey} = toString value; }
        ) attrs;

      # Convert config to template variables
      configVars = flattenConfig "" config;

      # Merge all variables (buildTimeConfig takes priority over config)
      allSubstitutions = configVars // buildTimeConfig;

      outputName = if name != null then name else "template-${baseNameOf (toString src)}";
    in
    pkgs.replaceVars src allSubstitutions;

  # Convenience function for common template patterns
  configTemplate =
    src: config: buildTimeConfig:
    templateFile { inherit src config buildTimeConfig; };
}
