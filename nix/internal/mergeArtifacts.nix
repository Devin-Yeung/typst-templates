{ lib }:
artifacts:
lib.fold lib.recursiveUpdate { } (
  map (doc: {
    inherit (doc) checks apps;
  }) artifacts
)
