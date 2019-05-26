{
  mobile-nixos
, fetchFromGitHub
, kernelPatches ? [] # FIXME
, dtbTool
}:

(mobile-nixos.kernel-builder-gcc6 {
  version = "4.4.153";
  configfile = ./config.aarch64;
  dtb = "unknown";
  #file = "vmlinuz-dtb";
  #file = "Image.gz";
  file = "Image.gz-dtb";
  # https://github.com/MiCode/Xiaomi_Kernel_OpenSource/tree/lavender-p-oss
  src = fetchFromGitHub {
    owner = "MiCode";
    repo = "Xiaomi_Kernel_OpenSource";
    rev = "1b35cb9e684cbc58867ee44718eb92e7ff951b3a";
    sha256 = "05khzdyk5dlm5zjarjfc5lqzb480g62skp83cirs81lgnyrav8cc";
  };

  patches = [
#    ./0001-Porting-changes-found-in-LineageOS-android_kernel_cy.patch
#    ./01_fix_gcc6_errors.patch
#    ./02_mdss_fb_refresh_rate.patch
#    ./05_dtb-fix.patch
#    ./99_framebuffer.patch
  ];

  isModular = false;

}).overrideAttrs({ postInstall ? "", postPatch ? "", ... }: {
  installTargets = [ "zinstall" "Image.gz-dtb" "install" ];
  postPatch = postPatch + ''
    cp -v "${./compiler-gcc6.h}" "./include/linux/compiler-gcc6.h"
  '';
  postInstall = postInstall + ''
    # FIXME : find proper make invocation.
    cp arch/arm64/boot/Image.gz-dtb $out/
    #set -x
    # Generate master DTB (deviceinfo_bootimg_qcdt)
    echo "Generating master DTB"
    ${dtbTool}/bin/dtbTool -s 2048 -p "scripts/dtc/" -o "arch/arm64/boot/dt.img" "$out/dtbs/qcom/"

    mkdir -p "$out/boot"
    cp "arch/arm64/boot/dt.img" \
             "$out/boot/dt.img"

    # Copies the dtb, could always be useful.
    (
    mkdir -p $out/dtb
    for prefix in / /qcom; do
      for f in arch/*/boot/dts/$prefix/*.dtb; do
        cp -v "$f" $out/dtb/$prefix
      done
    done
    )

    ## # Finally, makes Image.gz-dtb image ourselves.
    ## # Somehow the build system has issues.
    ## # FIXME: determine if required
    ## (
    ## cd $out
    ## shopt -s nullglob
    ## # FIXME
    ## cat Image.gz dtbs/qcom/sdm660-mtp-overlay.dtb > vmlinuz-dtb
    ## )
    ## #set +x
  '';
})
