#!/bin/bash

# Cập nhật hệ thống
sudo xbps-install -Suy

# Cài core X, i3 và trình khởi động
sudo xbps-install -y xorg-minimal xinit i3-gaps \
  lightdm lightdm-gtk3-greeter

# Giao diện đẹp
sudo xbps-install -y lxappearance arc-theme papirus-icon-theme gtk-engine-murrine feh

# Compositor, launcher, terminal
sudo xbps-install -y picom rofi xterm

# Hệ thống + âm thanh + mạng
sudo xbps-install -y alsa-utils pulseaudio pavucontrol \
  network-manager network-manager-applet \
  brightnessctl acpi acpid dbus

# Thanh polybar đẹp
sudo xbps-install -y polybar

# Tùy chọn: file manager + trình phát nhạc
sudo xbps-install -y thunar mpv cava

# Bật các dịch vụ cần thiết
for svc in NetworkManager lightdm acpid dbus; do
  sudo ln -sf /etc/sv/$svc /var/service
done

# Tạo thư mục config
mkdir -p ~/.config/{i3,polybar}

# i3 config cơ bản (có rofi, polybar, wallpaper, volume, brightness,…)
cat > ~/.config/i3/config <<'EOF'
set $mod Mod4
font pango:DejaVu Sans Mono 10

exec --no-startup-id picom
exec --no-startup-id feh --bg-scale /usr/share/backgrounds/void.png
exec --no-startup-id nm-applet
exec --no-startup-id volumeicon
exec_always --no-startup-id $HOME/.config/polybar/launch.sh

bindsym $mod+Return exec xterm
bindsym $mod+d exec rofi -show drun
bindsym $mod+Shift+q kill
bindsym $mod+Shift+r restart

# Âm lượng
bindsym XF86AudioRaiseVolume exec amixer set Master 5%+
bindsym XF86AudioLowerVolume exec amixer set Master 5%-
bindsym XF86AudioMute exec amixer set Master toggle

# Độ sáng
bindsym XF86MonBrightnessUp exec brightnessctl set +10%
bindsym XF86MonBrightnessDown exec brightnessctl set 10%-
EOF

# Polybar config cơ bản
cat > ~/.config/polybar/config.ini <<'EOF'
[bar/example]
width = 100%
height = 24
background = #222
foreground = #dfdfdf
font-0 = monospace;size=10

modules-left = i3
modules-center = date
modules-right = volume memory wlan

[module/i3]
type = internal/i3

[module/date]
type = internal/date
format = %a %d %b %H:%M

[module/volume]
type = internal/volume
format-volume = 🔊 %percentage%%
format-muted = 🔇 muted

[module/memory]
type = internal/memory
format = 🧠 %percentage_used%%

[module/wlan]
type = internal/network
interface-type = wireless
format-connected = 📶 %essid%
format-disconnected = ❌
EOF

# Script chạy polybar
cat > ~/.config/polybar/launch.sh <<'EOF'
#!/bin/bash
killall -q polybar
polybar example &
EOF

chmod +x ~/.config/polybar/launch.sh

# Wallpaper Void Linux
sudo mkdir -p /usr/share/backgrounds
curl -Lo /usr/share/backgrounds/void.png https://i.imgur.com/EYdXC7Q.png

# Xinit để startx nếu không dùng lightdm
echo "exec i3" > ~/.xinitrc

echo "✅ Cài đặt hoàn tất! Khởi động lại để vào giao diện i3 đẹp tối ưu."
