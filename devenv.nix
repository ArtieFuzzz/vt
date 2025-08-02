{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  languages.elixir.enable = true;

  git-hooks.hooks = {
    credo.enable = true;
    mix-format.enable = true;
    alejandra.enable = true;
  };

  packages = [pkgs.protobuf];
}
