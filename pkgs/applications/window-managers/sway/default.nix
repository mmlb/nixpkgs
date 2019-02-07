{ stdenv, fetchFromGitHub, makeWrapper
, meson, ninja
, pkg-config, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk-pixbuf, librsvg
, wlroots, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "sway";
  version = "unstable-2020-05-20g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = pname;
    rev = "45e4e9217238fe658b99634d284768439969ad79";
    sha256 = "1h7kcbrl86gpj6c5cs64jzw6kygrxxshkgljv1ivga0k6k6j8zqi";
  };

  patches = [
    ./sway-config-no-nix-store-references.patch
    ./load-configuration-from-etc.patch
  ];

  nativeBuildInputs = [
    pkg-config meson ninja scdoc
  ];

  buildInputs = [
    wayland libxkbcommon pcre json_c dbus libevdev
    pango cairo libinput libcap pam gdk-pixbuf librsvg
    wlroots wayland-protocols
  ];

  enableParallelBuilding = true;


  postPatch = ''
    sed -i "/^project(/,/^)/ s/\\bversion: '\([0-9]\.[0-9]\)'/version: '\1-${version}'/" meson.build
  '';

  meta = with stdenv.lib; {
    description = "i3-compatible tiling Wayland compositor";
    homepage    = "https://swaywm.org";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ma27 ];
  };
}
