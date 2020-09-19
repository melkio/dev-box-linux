#!/bin/bash

echo ">>>> Configure system settings"
timedatectl set-timezone Europe/Rome
update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo ">>>> Create custom user"
if ! id -u melkio &>/dev/null; then
    useradd --create-home \
            --gid users \
            --groups sudo \
            --comment "Alessandro Melchiori" \
            --password 3xFMtvGaxnEZs \
            --shell /bin/bash \
            melkio
    echo "melkio ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/99_melkio > /dev/null
fi

echo ">>>> Update packages"
apt-get update
apt-get upgrade -y

echo ">>>> Install basic packages"
apt-get install \
    build-essential autoconf \
    -y
apt-get install \
    firefox-esr gnome-terminal \
    git tree unzip jq \
    curl wget httpie \
    -y

echo ">>>> Install GUI packages"
apt-get install xorg i3 slim -y

# Other packages to install (evaluate)
# libreadline-dev
# suckless-tools
# xclip x11-utils autocutsel unclutter
# dbus-x11 libglib2.0-bin

echo ">>>> Configure and start slim..."
cp -r /vagrant/config/slim/greeny_dark /usr/share/slim/themes/
cp /vagrant/config/slim/slim.conf /etc/slim.conf

if service slim status | grep inactive; then
    service slim start
fi