final: prev:
let
  configFile = prev.writeText "config.def.h" (builtins.readFile ./config/config.def.h);
in
{
  st = prev.st.overrideAttrs (old: {
    patches = [
      # anysize patch (fix tiling wm sizing)
      (prev.fetchpatch {
        url = "https://st.suckless.org/patches/anysize/st-anysize-20220718-baa9357.diff";
        sha256 = "yx9VSwmPACx3EN3CAdQkxeoJKJxQ6ziC9tpBcoWuWHc=";
      })
      # no bold (solarized colors dependency)
      (prev.fetchpatch {
        url = "https://st.suckless.org/patches/solarized/st-no_bold_colors-20170623-b331da5.diff";
        sha256 = "iIGWeyvoPQ8CMQJiehCKvYhR0Oa1Cgqz/KFPU/NGxDk=";
      })
      # set COLORTERM env variable
      ./patches/truecolor.diff
    ];

    inherit configFile;
    postPatch = "${prev.st.postPatch}\n cp ${configFile} config.def.h";
  });
}
