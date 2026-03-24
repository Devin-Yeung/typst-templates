{ lib }:
artifacts:
lib.foldr lib.recursiveUpdate { } (
  map (doc: {
    inherit (doc) checks apps;
  }) artifacts
)
