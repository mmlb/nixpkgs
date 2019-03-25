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
    rev = "7d63d8cbd815e594c56e29c33518f2b9e9d9a919";
    sha256 = "1n3dcm4l2vbc6fmxqs95c3hc68k48kzsydg7w3q5s3x71sljbmz9";
  };
})
