#!/bin/bash
#minimalインストール後に実施。
echo "";echo `date`;echo "[BEGIN MATE INSTALL]"
#多重起動防止機講

# 同じ名前のプロセスが起動していたら起動しない。
_lockfile="/tmp/`basename $0`.lock"
ln -s /dummy $_lockfile 2> /dev/null || { echo 'Cannot run multiple instance.'; exit 9; }
trap "rm $_lockfile; exit" 1 2 3 4 5 6 7 8 15

echo "";echo `date`;echo "1[UPDATE]"
yum -y update || exit 1

echo "";echo `date`;echo "2[INSTALL YUM REMOVE PLUGIN]"
yum -y install yum-plugin-remove-with-leaves || exit 2

echo "";echo `date`;echo "3[INSTALL EPEL]"
yum -y install epel-release || exit 3

echo "";echo `date`;echo "4[INSTALL MATE DESKTOP]"
yum -y groupinstall "X Window system" || exit 4
yum -y groupinstall "MATE Desktop" || exit 4
systemctl set-default graphical.target || exit 4

#不要なソフトのアンインストール
echo "";echo `date`;echo "5[UNINSTALL_DEFAULT_PLAYER]"
yum -y remove --remove-leaves totem rhythmbox || exit 5

#サウンド出力用
#サウンドカード制御とミキサー
echo "";echo `date`;echo "6[INSTALL_SOUND_SUPPORT]"
yum -y install alsa-lib alsa-firmware alsa-tools alsa-utils pulseaudio pavucontrol alsa-plugins-pulseaudio pulseaudio-utils|| exit 6
#あとはpavucontrol(ミキサー)で適当に設定する。
#pulseaudio経由でないと面倒。ALSA直接だとfirefoxから音が出なかったりする。

echo "";echo `date`;echo "7[CONFIGURE_INPUT_METHOD]"
echo '
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
' > "/etc/profile.d/im_module.sh" || exit 7

#システム ⇒ コントロールセンター ⇒ 自動起動するアプリ
#設定項目 	設定値
#名前 	ibus daemon
#コマンド 	ibus-daemon -rdx
#説明 	start ibus daemon
echo "";echo `date`;echo "8[CONFIGURE_MATE_INPUT_METHOD]"
echo '
[Desktop Entry]
Type=Application
Exec=ibus-daemon -rdx
Hidden=false
X-MATE-Autostart-enabled=true
Name[ja_JP]=ibus daemon
Name=ibus daemon
Comment[ja_JP]=start ibus daemon
Comment=start ibus daemon
' > "/etc/xdg/autostart/ibus-daemon.desktop" || exit 8

echo "";echo `date`;echo "[COMPLETE MATE INSTALL]"
rm $_lockfile
