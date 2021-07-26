#! /bin/bash
echo "start sync codes"
#cd ~/Documents/codes/O-M01-MASTER_bk/.repo
#rm -rf ./manifests &&
#rm -rf manifests.git &&
cd ~/Documents/codes/O-M01-MASTER_bk/Linux/android
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx16g"
./prebuilts/sdk/tools/jack-admin kill-server
./prebuilts/sdk/tools/jack-admin start-server
#repo init --depth 1 -u ssh://wangwei1@gerrit.it.chehejia.com:29418/platform/manifest -b O-M01-MASTER --repo-url ssh://wangwei1@gerrit.it.chehejia.com:29418/git-repo &&
#repo sync -c -q --no-tags -j8 &&
cd ~/Documents/codes/O-M01-MASTER_bk
source env_setup.sh chehejia M01_AE-userdebug &&
make update-api &&
make android
echo "done"
