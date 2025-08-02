{ pkgs, lib, config, inputs, ... }:

{
  languages.elixir.enable = true;

  packages = [ pkgs.protobuf ];
}
