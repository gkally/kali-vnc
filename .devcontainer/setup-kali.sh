#!/bin/bash
set -e
echo "[*] Installing Kali tools..."
sudo apt-get update -y
sudo apt-get install -y kali-linux-headless nmap metasploit-framework wireshark aircrack-ng hydra john sqlmap gobuster nikto netcat-openbsd tcpdump python3-pip git curl wget
echo "[*] Kali tools installed."
echo "[*] Desktop password: kali | VNC password: kali"