
set -e
lsb_release -a

BUILD_DIR=/home/runner/
DATA=~/CloudSpace/data/games/mcpi

install() {
  echo [*] Installing packages
  install-pkg libc6 libstdc++6 libc6-armhf-cross libstdc++6-armhf-cross zenity libgles1 libegl1 libglfw3 libfreeimage3 qemu-user-static patchelf wmctrl libopenal1 zenity

  echo [*] Setting up game
  dpkg -x $DATA/minecraft-pi-reborn-client_2.2.8_amd64.deb $BUILD_DIR/.apt

  patchelf --set-interpreter $BUILD_DIR/.apt/usr/arm-linux-gnueabihf/lib/ld-linux-armhf.so.3 $BUILD_DIR/.apt/opt/minecraft-pi-reborn-client/minecraft-pi

  # Install sound file and updated texture override
  mkdir -p $BUILD_DIR/.minecraft-pi/overrides
  cp -r $DATA/overrides/* $BUILD_DIR/.minecraft-pi/overrides
  chmod +x $DATA/fullscreen.sh
  touch $BUILD_DIR/patched
}

[ ! -f $BUILD_DIR/patched ] && install
# Maximise game on launch with 1 second delay
$DATA/fullscreen.sh &


# Run client (adjust launch flags if wanted, just add the flags you want to enable seperated by "|")
GALLIUM_HUD=simple,.x690fps LD_LIBRARY_PATH="$BUILD_DIR/.apt/usr/arm-linux-gnueabihf/lib:$BUILD_DIR/.apt/usr/lib/x86_64-linux-gnu" MCPI_FEATURE_FLAGS='Touch GUI|Fix Bow & Arrow|Fix Attacking|Display Nametags By Default|Fix Sign Placement|Show Block Outlines|Expand Creative Inventory|Remove Creative Mode Restrictions|Animated Water|Remove Invalid Item Background|Disable "gui_blocks" Atlas|Fix Camera Rendering|Implement Chat|Implement Death Messages|Implement Game-Mode Switching|Allow Joining Survival Servers|Miscellaneous Input Fixes|Bind "Q" Key To Item Dropping|Bind Common Toggleable Options To Function Keys|Render Selected Item Text|External Server Support|Load Language Files|Implement Sound Engine' MCPI_RENDER_DISTANCE='Short' MCPI_USERNAME='Replit' minecraft-pi-reborn-client