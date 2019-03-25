{stdenv, fetchFromGitHub, libgit2_0_27, ...}:

let romkatvLibgit2 = libgit2_0_27.overrideDerivation (old: {
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
    rev = "7d63d8cbd815e594c56e29c33518f2b9e9d9a919";
    owner = "romkatv";
    repo = "libgit2";
    sha256 = "1n3dcm4l2vbc6fmxqs95c3hc68k48kzsydg7w3q5s3x71sljbmz9";
  };
});

in

stdenv.mkDerivation rec {
  name = "gitstatus-${version}";
  version = "20190325";

  src = fetchFromGitHub {
    owner  = "romkatv";
    repo   = "gitstatus";
    rev    = "e1a61e76ccc74bd9d0f637724af7a9c0641ae85b";
    sha256 = "1qza78k0f348f0jp3ap40cq7bbykkf7cp0h83hq56qijisp7kwif";
  };

  buildInputs = [ romkatvLibgit2 ];
  installPhase = ''
    install -Dm755 gitstatusd $out/bin/gitstatusd
    install -Dm444 gitstatus.plugin.zsh $out
    sed -i "s|local daemon.*|local daemon=$out/bin/gitstatusd|" $out/gitstatus.plugin.zsh
  '';

  meta = with lib; {
    description = "eradicate removes commented-out code from Python files.";
    homepage = https://github.com/myint/eradicate;
    license = [ licenses.gpl3 ];

    maintainers = [ maintainers.mmlb ];
  };
}
