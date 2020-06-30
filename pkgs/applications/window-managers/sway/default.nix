{ stdenv, fetchFromGitHub, makeWrapper
, meson, ninja, pkg-config, wayland, scdoc
, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk-pixbuf, librsvg
, wlroots, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "sway";
  version = "unstable-2020-06-30g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = pname;
    rev = "76adcc3fd3aca74bf45db69d6dbcf3a8443ff159";
    sha256 = "1jnvjvaj86cf7hzjsqzz6jh4vgrjlb2l5bj1ysaksl7xq6qcq5bf";
  };

  patches = [
    ./sway-config-no-nix-store-references.patch
    ./load-configuration-from-etc.patch
  ];

  postPatch = ''
    substituteInPlace meson.build --replace "1.5" "1.5-${version}"
  '';

  nativeBuildInputs = [
    meson ninja pkg-config wayland scdoc
  ];

  buildInputs = [
    wayland libxkbcommon pcre json_c dbus libevdev
    pango cairo libinput libcap pam gdk-pixbuf librsvg
    wlroots wayland-protocols
  ];

  mesonFlags = [
    "-Ddefault-wallpaper=false"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An i3-compatible tiling Wayland compositor";
    longDescription = ''
      Sway is a tiling Wayland compositor and a drop-in replacement for the i3
      window manager for X11. It works with your existing i3 configuration and
      supports most of i3's features, plus a few extras.
      Sway allows you to arrange your application windows logically, rather
      than spatially. Windows are arranged into a grid by default which
      maximizes the efficiency of your screen and can be quickly manipulated
      using only the keyboard.
    '';
    homepage    = "https://swaywm.org";
    changelog   = "https://github.com/swaywm/sway/releases/tag/${version}";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ma27 ];
  };
}
