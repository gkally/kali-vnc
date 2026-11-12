#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

echo "[*] Kali XFCE + VNC setup (individual packages, no meta)..."
apt-get update -y

apt-get install -y --no-install-recommends \
  xfce4 xfce4-goodies xfce4-terminal xfwm4 xfdesktop4 xfce4-panel xfce4-session \
  dbus-x11 x11-xserver-utils \
  tigervnc-standalone-server tigervnc-xorg-extension \
  novnc websockify \
  firefox-esr xterm htop neofetch git curl wget unzip \
  nmap sqlmap hydra john gobuster nikto netcat-openbsd tcpdump wireshark aircrack-ng

echo "[*] Configuring VNC..."
mkdir -p /root/.vnc
echo "kali" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

cat > /root/.vnc/xstartup <<'EOS'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=XFCE
eval $(dbus-launch --sh-syntax)
exec startxfce4
EOS
chmod +x /root/.vnc/xstartup

cat > /usr/local/bin/start-vnc.sh <<'EOS'
#!/bin/bash
pkill Xvnc 2>/dev/null || true
pkill websockify 2>/dev/null || true
sleep 2
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null || true
vncserver :1 -geometry 1600x900 -depth 24 -SecurityTypes VncAuth
sleep 2
websockify --web=/usr/share/novnc/ 6080 localhost:5901 > /tmp/websockify.log 2>&1 &
sleep 2
EOS
chmod +x /usr/local/bin/start-vnc.sh

echo "[*] Starting VNC..."
/usr/local/bin/start-vnc.sh

echo "[*] DONE. VNC password: kali"
ss -tlnp | grep -E "6080|5901" || echo "WARNING: ports not listening"