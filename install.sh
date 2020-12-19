pushd /tmp/

echo "Start donwloading latest version YoMo ..."

curl -s https://api.github.com/repos/yomorun/yomo/releases/latest \
    | grep "browser_download_url.*tar.gz" \
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
