{ lib, ... }:
dir:
  lib.trivial.pipe dir [
    builtins.readDir
    (lib.attrsets.filterAttrs (name: value: value == "directory"))
    (lib.attrsets.mapAttrsToList (name: value: name))
  ]
