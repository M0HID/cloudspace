clear
pkill -9 top
pkill -9 java
pkill -9 minecraft-pi
pkill -9 fluxbox
pkill -9 xterm
pkill -9 minecraft-launcher

chmod +x ~/CloudSpace/data/mc.sh
echo [*] Starting Fluxbox

mkdir -p ~/.fluxbox
cp ~/CloudSpace/data/.fluxboxmenu ~/.fluxbox/menu
fluxbox &

install-pkg xterm firefox chromium-browser