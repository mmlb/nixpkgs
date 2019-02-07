{stdenv, fetchFromGitHub, libgit2_0_27, ...}:

libgit2_0_27.overrideDerivation (old: {
  cmakeFlags = old.cmakeFlags ++ [
    "-DUSE_BUNDLED_ZLIB=ON"
    "-DUSE_ICONV=OFF"
    "-DBUILD_CLAR=OFF"
    "-DUSE_SSH=OFF"
    "-DUSE_HTTPS=OFF"
    "-DBUILD_SHARED_LIBS=OFF"
    "-DUSE_EXT_HTTP_PARSER=OFF"
  ];

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "libgit2";
    rev = "a4d11f3a82b1ef3bd0a0a3750f773fd08f60a77e";
    sha256 = "1n7wff9drdpphyhmjs3fgx4xfxj2klb361m94v9rqbiyy3m9wxk3";
  };
})
