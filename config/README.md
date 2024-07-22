## 配置
```bash
localectl set-keymap us
localectl set-locale LANG=zh_CN.UTF-8
timedatectl set-timezone Asia/Shanghai

## 调整声卡顺序, lspci -nn | grep -i audio, 修改后面两个ID
tee >/etc/modprobe.d/alsa-base.conf <<EOF
options snd-hda-intel index=0 model=auto vid=1022 pid=15e3
options snd-hda-intel index=1 model=auto vid=1002 pid=1637
EOF
## 插入鼠标禁用触摸板
tee >/etc/udev/rules.d/01-touchpad.rules <<EOF
SUBSYSTEM=="input", ATTRS{name}=="RAPOO BT4.0 Mouse", ACTION=="add", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/x/.Xauthority", RUN+="/usr/bin/xinput --disable 'UNIW0001:00 093A:0255 Touchpad'"
SUBSYSTEM=="input", ATTRS{name}=="RAPOO BT4.0 Mouse", ACTION=="remove", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/x/.Xauthority", RUN+="/usr/bin/xinput --enable 'UNIW0001:00 093A:0255 Touchpad'"
EOF

# 关机之前记住网卡和蓝牙锁状态
rfkill unlock all
systemctl restart systemd-rfkill
systemctl enable systemd-rfkill
systemctl restart NetworkManager.service
systemctl enable NetworkManager.service
systemctl enable NetworkManager-wait-online.service
systemctl start alsa-restore
systemctl enable alsa-restore

## systemd配置
echo 'HandlePowerKey=hibernate' >>/etc/systemd/logind.conf
tee >>/etc/systemd/system.conf <<EOF
DefaultTimeoutStartSec=10s
DefaultTimeoutStopSec=10s
EOF
systemctl enable docker.service
## systemd.serivce
tee >>/etc/systemd/system/slock@.service <<EOF
[Unit]
Description=Lock X session using slock for user %i
Before=sleep.target

[Service]
User=%i
Environment=DISPLAY=:0
ExecStartPre=/usr/bin/xset dpms force suspend
ExecStart=/usr/bin/slock

[Install]
WantedBy=sleep.target
EOF
systemctl enable slock@x

## user
useradd -m -G wheel -s /bin/zsh x
echo 'x:x' | chpasswd

## xorg config
cp -f ./00-myinput.conf /etc/X11/xorg.conf.d
# tty key map
cp -f ./us.map.gz /usr/share/keymaps/i386/qwerty/us.map.gz
# xorg key map
cp -f ./pc /usr/share/X11/xkb/symbols/pc
### 声卡
cp -f ./.asoundrc /home/x
```