{
  mobile-nixos
, fetchFromGitHub
, kernelPatches ? [] # FIXME
, dtbTool
}:

(mobile-nixos.kernel-builder-gcc6 {
  version = "3.4.113";
  configfile = ./config-oneplus-bacon.armhf;
  #file = "vmlinuz-dtb";
  file = "zImage";
  src = fetchFromGitHub {
    owner = "LineageOS";
    repo = "android_kernel_oneplus_msm8974";
    rev = "dd65620ba04a8c6ba0e30553c9c95388daefae02";
    sha256 = "13zfa7wr38i3phy145i2hz1v70ycgqicdzzkcfv0yyy6kjxnnsd7";
  };

  patches = [
    ./0001-fix-video-argb-setting.patch
    ./02_gpu-msm-fix-gcc5-compile.patch
    ./mdss_fb_refresh_rate.patch
    ./0001-Section-mismatch.patch
    ./90_dtbs-install.patch
  ];

  isModular = false;

}).overrideAttrs({ postInstall ? "", postPatch ? "", ... }: {
  installTargets = [ "zinstall" "dtbs" ];
  postPatch = postPatch + ''
    cp -v "${./compiler-gcc6.h}" "./include/linux/compiler-gcc6.h"
  '';
  postInstall = postInstall + ''
    mkdir -p "$out/dtbs"
    ${dtbTool}/bin/dtbTool -s 2048 -p "scripts/dtc/" -o "arch/arm/boot/oneplus-bacon.img" "arch/arm/boot/"
    cp "arch/arm/boot/oneplus-bacon.img" "$out/dtbs/oneplus-bacon.img"

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
