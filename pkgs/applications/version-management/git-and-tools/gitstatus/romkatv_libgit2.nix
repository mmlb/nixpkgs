{ fetchFromGitHub, libgit2, ...}:

libgit2.overrideAttrs (oldAttrs: {
  cmakeFlags = oldAttrs.cmakeFlags ++ [
    "-DBUILD_CLAR=OFF"
    "-DBUILD_SHARED_LIBS=OFF"
    "-DREGEX_BACKEND=builtin"
    "-DUSE_BUNDLED_ZLIB=ON"
    "-DUSE_HTTPS=OFF"
    "-DUSE_HTTP_PARSER=builtin"  # overwritten from libgit2
    "-DUSE_ICONV=OFF"
    "-DUSE_SSH=OFF"
    "-DZERO_NSEC=ON"
  ];
  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "libgit2";
    rev = "c52ffd4b01d4d11366d27264fe405c88fd426eab";
    sha256 = "0b00kr895fjssr26vi2h45vxpcgjs1d2i4hwpa92zx9pw6bmxkcz";
  };
})
