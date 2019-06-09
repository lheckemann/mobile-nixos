{
  mobile-nixos
, fetchFromGitHub
, kernelPatches ? [] # FIXME
}:

(mobile-nixos.kernel-builder-gcc6 {
  version = "3.4.113";
  configfile = ./config-oneplus-bacon.armhf;
  #file = "vmlinuz-dtb";
  file = "zImage";
  src = fetchFromGitHub {
    owner = "LineageOS";
    repo = "android_kernel_oppo_msm8974";
    rev = "aa55f9814659a4642a9a7f3541d3d8dc4007b5e9";
    sha256 = "0ss651fxmzs58b1s9nqvgg92lh6c9w2a3x3zarf4n9h16nzr3aps";
  };

  patches = [
    #./0001-fix-video-argb-setting.patch
    #./02_gpu-msm-fix-gcc5-compile.patch
    #./mdss_fb_refresh_rate.patch
    ./0001-Section-mismatch.patch
  ];

  isModular = false;

}).overrideAttrs({ postInstall ? "", postPatch ? "", ... }: {
  installTargets = [ "zinstall" ];
  postPatch = postPatch + ''
    cp -v "${./compiler-gcc6.h}" "./include/linux/compiler-gcc6.h"
  '';
  postInstall = postInstall + ''
    mkdir -p "$out/boot"

    # FIXME factor this out properly
    # Copies all potential output files.
    for f in zImage-dtb Image.gz-dtb zImage Image.gz Image; do
      f=arch/arm/boot/$f
      [ -e "$f" ] || continue
      echo "zImage found: $f"
      cp -v "$f" "$out/"
      break
    done

    mkdir -p $out/dtb
    for f in arch/*/boot/dts/*.dtb; do
      cp -v "$f" $out/dtb/
    done

  '';
})
