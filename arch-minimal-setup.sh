#!/bin/bash

set -e

echo "[*] Cập nhật hệ thống..."
sudo pacman -Syu --noconfirm

echo "[*] Cài Xorg và các thành phần cần thiết..."
sudo pacman -S --noconfirm xorg-server xorg-xinit xorg-xrandr xorg-xsetroot

echo "[*] Cài i3-gaps, công cụ và tiện ích..."
sudo pacman -S --noconfirm i3-gaps i3status i3lock dmenu rofi picom feh dunst \
    ttf-dejavu ttf-jetbrains-mono

echo "[*] (Tuỳ chọn) Cài polybar..."
read -p "Bạn có muốn cài Polybar? (y/n): " poly
if [[ $poly == "y" || $poly == "Y" ]]; then
    sudo pacman -S --noconfirm polybar
fi

echo "[*] Cài thêm công cụ GTK Theme..."
sudo pacman -S --noconfirm lxappearance

echo "[*] Tạo cấu hình mặc định cho i3..."
mkdir -p ~/.config/i3
cp /etc/i3/config ~/.config/i3/config

# Thêm autostart vào i3 config
cat <<EOT >> ~/.config/i3/config

# --- Autostart ---
exec --no-startup-id picom --config ~/.config/picom/picom.conf
exec --no-startup-id feh --bg-fill ~/Pictures/wallpaper.jpg
exec --no-startup-id dunst
exec --no-startup-id nm-applet
EOT

echo "[*] Tạo config Picom nhẹ..."
mkdir -p ~/.config/picom
cat <<EOT > ~/.config/picom/picom.conf
backend = "xrender";
vsync = true;
shadow = false;
fading = true;
fade-in-step = 0.03;
fade-out-step = 0.03;
opacity-rule = [ "90:class_g = 'Rofi'" ];
EOT

echo "[*] Tạo file ~/.xinitrc để chạy i3..."
echo "exec i3" > ~/.xinitrc

echo "[*] Tạo thư mục Pictures nếu chưa có..."
mkdir -p ~/Pictures

echo "[*] Tải wallpaper đơn giản..."
curl -L -o ~/Pictures/wallpaper.jpg https://i.imgur.com/ExdKOOz.jpeg

echo "[✔] Cài đặt hoàn tất!"
echo "Khởi động i3 bằng lệnh: startx"
