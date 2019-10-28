{ mobile-nixos
, fetchFromGitHub
, kernelPatches ? []
, dtbTool
, buildPackages
}:
let inherit (buildPackages) dtc; in
(mobile-nixos.kernel-builder-gcc6 {
  version = "4.9.188";
  configfile = ./config;
  file = "Image.gz-dtb";
  hasDTB = true;
  src = fetchFromGitHub {
    owner = "lineageos";
    repo = "android_kernel_xiaomi_msm8953";
    rev = "337f9d5a8111b22f7a22cfaf3a3ab17370369e61";
    sha256 = "0wq7glwi5rdysg8lpy80skyr04qzmdqv8zlc7sf0n9iazz4mavkw";
  };
  patches = [
    ../../xiaomi-lavender/kernel/0003-arch-arm64-Add-config-option-to-fix-bootloader-cmdli.patch
    ../../xiaomi-lavender/kernel/0001-mobile-nixos-Workaround-selected-processor-does-not-.patch
  ];

  postPatch = ''
    # Remove -Werror from all makefiles
    local i
    local makefiles="$(find . -type f -name Makefile)
    $(find . -type f -name Kbuild)"
    for i in $makefiles; do
      sed -i 's/-Werror-/-W/g' "$i"
      sed -i 's/-Werror//g' "$i"
    done
    echo "Patched out -Werror"
  '';

  makeFlags = [ "DTC_EXT=${dtc}/bin/dtc" ];

  isModular = false;
}).overrideAttrs ({ postInstall ? "", postPatch ? "", ... }: {
  installTargets = [ "Image.gz" "zinstall" "Image.gz-dtb" "install" ];
  postInstall = postInstall + ''
    cp $buildRoot/arch/arm64/boot/Image.gz-dtb $out/
  '';
})
