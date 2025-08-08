#!/bin/bash

# Cập nhật hệ thống
sudo xbps-install -Suy

# Cài gói cần thiết
sudo xbps-install -y xorg-minimal xinit i3 rofi picom feh \
  dmenu lightdm lightdm-gtk3-greeter \
  network-manager network-manager-applet \
  alsa-utils pulseaudio papirus-icon-theme arc-theme gtk-engine-murrine lxappearance

# Bật dịch vụ mạng + lightdm
sudo ln -s /etc/sv/NetworkManager /var/service
sudo ln -s /etc/sv/lightdm /var/service

# Tạo ~/.xinitrc nếu cần
echo 'exec i3' > ~/.xinitrc

# Cấu hình wallpaper và applet khởi động cùng i3
mkdir -p ~/.config/i3

cat > ~/.config/i3/config <<EOF
set \$mod Mod4
font pango:DejaVu Sans Mono 10

exec --no-startup-id nm-applet
exec --no-startup-id feh --bg-scale /usr/share/backgrounds/void.png
exec --no-startup-id picom

bindsym \$mod+Return exec xterm
bindsym \$mod+d exec rofi -show run
bindsym \$mod+Shift+q kill
bindsym \$mod+Shift+r restart

# Âm lượng
bindsym XF86AudioRaiseVolume exec amixer set Master 5%+
bindsym XF86AudioLowerVolume exec amixer set Master 5%-
bindsym XF86AudioMute exec amixer set Master toggle
EOF

# Tải wallpaper nhẹ (biểu tượng Void Linux)
sudo mkdir -p /usr/share/backgrounds
curl -Lo /usr/share/backgrounds/void.png https://i.imgur.com/EYdXC7Q.png

echo "✅ Cài đặt hoàn tất. Khởi động lại và đăng nhập vào LightDM để sử dụng i3."
