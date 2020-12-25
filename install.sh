_ostype="$(uname -s)"
_cputype="$(uname -m)"

if [ "$_ostype" = Darwin ] && [ "$_cputype" = i386 ]; then
  # Darwin `uname -m` lies
  if sysctl hw.optional.x86_64 | grep -q ': 1'; then
    _cputype=amd64
  fi
fi

case "$_ostype" in
  Linux)
    _ostype=linux
    ;;

  FreeBSD)
    _ostype=freebsd
    ;;

  Darwin)
    _ostype=darwin
    ;;

  *)
    err "unrecognized OS type: $_ostype"
    ;;
esac

case "$_cputype" in
  i386 | i486 | i686 | i786 | x86)
    _cputype=386
    ;;

  xscale | arm | armv6l | armv7l |armv8l)
    _cputype=arm
    ;;

  aarch64 | x86_64 | x86-64 | x64 | amd64)
    _cputype=amd64
    ;;

  *)
    err "unknown CPU type: $_cputype"
esac

_arch="${_ostype}-${_cputype}"

pushd /tmp/

echo "Start donwloading latest version YoMo ..."

curl -s https://api.github.com/repos/yomorun/yomo/releases/latest \
    | grep "browser_download_url."$_arch".tar.gz" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -

tarball="$(find . -iname "yomo-*darwin.tar.gz")"
tar -xzf $tarball

bfile="$(find . -iname "yomo*-darwin")"

chmod +x $bfile

mv $bfile /usr/local/bin/yomo

rm -f $tarball $bfile

popd

location="$(which yomo)"
echo "YoMo binary localtion: $location"
