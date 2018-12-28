# based on https://nixos.wiki/wiki/Overlays

self: super: with super.lib;

let
  # Using the nixos plumbing that's used to evaluate the config...
  eval = (traceSeq "boboo" import <nixpkgs/nixos/lib/eval-config.nix>);
  # Evaluate the config,
  paths = (eval {modules = [(import <nixos-config>)];})
    # then get the `nixpkgs.overlays` option.
    .config.nixpkgs.overlays
  ;
in
foldl' (flip extends) (_: super) (traceSeq "booo" paths) self
