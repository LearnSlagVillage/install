say() {
	printf '>>>> yomo installer: %s\n' "$1"
}

err() {
	say "$1" >&2
	exit 1
}

ensure() {
	if ! "$@"; then err "command failed: $*"; fi
}

_cputype="$(uname -m)"
_ostype="$(uname)"

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

pattern="browser_download_url(.*)${_arch}.tar.gz"

pushd /tmp/

say "Start donwloading latest version YoMo ..."

curl -s https://api.github.com/repos/yomorun/yomo/releases/latest \
	| grep -E $pattern \
	| cut -d : -f 2,3 \
	| tr -d \" \
	| xargs wget

tarball="$(find . -iname "yomo-*.tar.gz")"

say "tarball:$tarball"

ensure tar -xzf $tarball

ensure rm -rf $tarball

bfile="$(find . -iname "yomo*")"

say "bfile: $bfile"

chmod u+x $bfile

echo "mv 1"
ensure mv $bfile ./yomo
mkdir -p ~/.yomo
echo "mv 2"
ensure mv ./yomo ~/.yomo/.

rm -f yomo*

popd

echo "=============================="
echo "YoMo binary localtion: ~/.yomo"
echo "=============================="

echo "add \"export PATH=\$PATH:~/.yomo\" to your bash or zsh"
