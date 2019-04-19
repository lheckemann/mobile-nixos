{
  mobile-nixos
, fetchFromGitLab
, kernelPatches ? [] # FIXME
}:

mobile-nixos.kernel-builder {
  version = "5.0.0-rc3-next-20190124";
  configfile = ./config.aarch64;
  dtb = "allwinner/sun50i-a64-dontbeevil.dtb";
  patches = [
    ./dtb-add.patch
  ];
  postPatch = ''
     cp ${./sun50i-a64-dontbeevil.dts} arch/arm64/boot/dts/allwinner/sun50i-a64-dontbeevil.dts
  '';
  src = fetchFromGitLab {
    owner = "pine64-org";
    repo = "linux";
    rev = "a91169202e61c4876dde06a5548d76a385306d05";
    sha256 = "1p6vml453n2ghaw93qgy6qyysfbpnfs529y60243lgr5slx9xr0m";
  };
}
