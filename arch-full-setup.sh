#!/bin/bash
# ============================================
# Arch Linux i3 Full Setup (Hyprland-like)
# ============================================

set -e

echo "[*] Cập nhật hệ thống..."
sudo pacman -Syu --noconfirm

echo "[*] Cài Xorg và trình quản lý cửa sổ i3-gaps..."
sudo pacman -S --noconfirm xorg-server xorg-xinit xorg-xrandr xorg-xsetroot \
    i3-gaps i3status i3lock dmenu rofi picom feh dunst \
    ttf-dejavu ttf-jetbrains-mono

echo "[*] Cài polybar, lxappearance, các gói theme..."
sudo pacman -S --noconfirm polybar lxappearance papirus-icon-theme arc-gtk-theme

echo "[*] Cài terminal Alacritty..."
sudo pacman -S --noconfirm alacritty

echo "[*] Tạo cấu hình i3..."
mkdir -p ~/.config/i3
cat <<'EOT' > ~/.config/i3/config
set \$mod Mod4

# --- Cửa sổ ---
bindsym \$mod+Return exec alacritty
bindsym \$mod+Shift+q kill
bindsym \$mod+d exec rofi -show drun
bindsym \$mod+f fullscreen toggle
bindsym \$mod+Shift+e exec "i3-msg exit"

# --- Workspace ---
bindsym \$mod+1 workspace 1
bindsym \$mod+2 workspace 2
bindsym \$mod+3 workspace 3
bindsym \$mod+4 workspace 4
bindsym \$mod+Shift+1 move container to workspace 1
bindsym \$mod+Shift+2 move container to workspace 2
bindsym \$mod+Shift+3 move container to workspace 3
bindsym \$mod+Shift+4 move container to workspace 4

# --- Gaps ---
gaps inner 10
gaps outer 5

# --- Autostart ---
exec --no-startup-id picom --config ~/.config/picom/picom.conf
exec --no-startup-id feh --bg-fill ~/Pictures/wallpaper.jpg
exec --no-startup-id dunst
exec --no-startup-id nm-applet
exec_always --no-startup-id ~/.config/polybar/launch.sh

bar {
    status_command i3status
}
EOT

echo "[*] Cấu hình picom với blur và fade..."
mkdir -p ~/.config/picom
cat <<EOT > ~/.config/picom/picom.conf
backend = "glx";
vsync = true;
corner-radius = 8;
shadow = true;
shadow-radius = 12;
fading = true;
fade-in-step = 0.03;
fade-out-step = 0.03;
blur-method = "dual_kawase";
blur-strength = 6;
opacity-rule = [ "90:class_g = 'Rofi'", "90:class_g = 'Alacritty'" ];
EOT

echo "[*] Tải wallpaper..."
mkdir -p ~/Pictures
curl -L -o ~/Pictures/wallpaper.jpg https://i.imgur.com/ExdKOOz.jpeg

echo "[*] Cấu hình Polybar..."
mkdir -p ~/.config/polybar
cat <<'EOT' > ~/.config/polybar/config.ini
[bar/main]
width = 100%
height = 30
background = #222
foreground = #fff
modules-left = workspaces
modules-center = date
modules-right = pulseaudio memory cpu battery

[module/workspaces]
type = internal/xworkspaces

[module/date]
type = internal/date
interval = 5
date = %Y-%m-%d %H:%M

[module/pulseaudio]
type = internal/pulseaudio

[module/memory]
type = internal/memory

[module/cpu]
type = internal/cpu

[module/battery]
type = internal/battery
EOT

cat <<'EOT' > ~/.config/polybar/launch.sh
#!/bin/bash
killall -q polybar
while pgrep -x polybar >/dev/null; do sleep 1; done
polybar main &
EOT
chmod +x ~/.config/polybar/launch.sh

echo "[*] Tạo ~/.xinitrc..."
echo "exec i3" > ~/.xinitrc

echo "[✔] Cài đặt hoàn tất!"
echo "Khởi động i3 bằng: startx"
