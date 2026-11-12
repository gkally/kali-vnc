#!/bin/bash
set -e
echo "[*] Installing Kali XFCE + VNC + noVNC..."
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  kali-linux-default kali-desktop-xfce \
  tigervnc-standalone-server tigervnc-xorg-extension \
  novnc websockify dbus-x11 firefox-esr \
  xterm htop nmap sqlmap hydra john gobuster nikto \
  netcat-openbsd tcpdump wireshark aircrack-ng git curl wget

echo "[*] Configuring VNC..."
mkdir -p ~/.vnc
echo "kali" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

cat > ~/.vnc/xstartup <<'EOS'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=XFCE
eval $(dbus-launch --sh-syntax)
exec startxfce4
EOS
chmod +x ~/.vnc/xstartup

cat > /usr/local/bin/start-vnc.sh <<'EOS'
#!/bin/bash
pkill Xvnc 2>/dev/null || true
pkill websockify 2>/dev/null || true
sleep 1
vncserver :1 -geometry 1600x900 -depth 24 -SecurityTypes VncAuth
websockify --web=/usr/share/novnc/ 6080 localhost:5901 >/tmp/websockify.log 2>&1 &
EOS
chmod +x /usr/local/bin/start-vnc.sh

# Auto-start on container boot
echo "/usr/local/bin/start-vnc.sh" >> ~/.bashrc
/usr/local/bin/start-vnc.sh

echo "[*] DONE. VNC password: kali"