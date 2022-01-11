#! /bin/sh -
PROGNAME=$0

# (-o) -> official mc launcher
# (-k) -> SKLauncher
# (-p) -> minecraft pi
mkdir -p /home/runner/.data

GM_DIR=~/CloudSpace/data/games
DATA_DIR=/home/runner/.data


mojang() {
  chmod +x $GM_DIR/mcofficial/minecraft-launcher
  $GM_DIR/mcofficial/minecraft-launcher
}

sklauncher() {
cd $DATA_DIR

 curl -o "$DATA_DIR/jre.tar.gz" "https://download.bell-sw.com/java/8u312+7/bellsoft-jre8u312+7-linux-amd64-full.tar.gz"
tar -xf jre.tar.gz

$DATA_DIR/jre8u312-full/bin/java -jar $GM_DIR/sklauncher/SKlauncher.jar
}

mcpi() {
  chmod +x $GM_DIR/mcpi/mcpi.sh
  $GM_DIR/mcpi/mcpi.sh
}
h=0
while getopts okp o; do
  case $o in
    (o) mojang;;
    (k) sklauncher;;
    (p) mcpi;;
    (*) echo "err, missing GM";exit 1;;
  esac
done
shift "$((OPTIND - 1))"