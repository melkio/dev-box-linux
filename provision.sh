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

echo ">>>> Install GUI packages"
add-apt-repository ppa:regolith-linux/release
apt-get install regolith-desktop-standard -y

echo ">>>> Install basic packages"
apt-get install \
    build-essential autoconf \
    dirmngr gpg dconf-cli gnupg-agent software-properties-common \
    apt-transport-https ca-certificates \
    gnome-terminal bash-completion \
    git tree unzip jq \
    curl wget httpie \
    -y

echo ">>>> Install dotnet core deps"
apt-get install libcurl4-openssl-dev zlib1g -y

echo ">>>> Install Azure Data Studio deps"
apt-get install libunwind8 -y

echo ">>>> Install erlang deps"
apt-get install m4 \
    libncurses5-dev \
    libwxgtk3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev \
    libssh-dev \
    unixodbc-dev \
    xsltproc fop libxml2-utils libncurses-dev \
    -y

echo ">>>> Install docker and docker-compose"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y
usermod -aG docker melkio

sudo curl -L "https://github.com/docker/compose/releases/download/1.27.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo ">>>> Install Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get install ./google-chrome-stable_current_amd64.deb -y
rm ./google-chrome-stable_current_amd64.deb

echo ">>>> Install VS Code"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
apt-get update
apt-get install code -y

echo ">>>> Install Azure Data Studio"
wget https://sqlopsbuilds.azureedge.net/stable/2413919f186f780f0193d047da3d90bb3c1e9bf6/azuredatastudio-linux-1.21.0.deb
apt-get install ./azuredatastudio-linux-1.21.0.deb -y
rm ./azuredatastudio-linux-1.21.0.deb

echo ">>>> Install Insomnia"
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc | apt-key add -
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" > /etc/apt/sources.list.d/insomnia.list
apt-get update
apt-get install insomnia -y

sudo -iu melkio <<HEREDOC
    echo ">>>> Configure ssh keys"
    if [ ! -f /vagrant/id_rsa ]; then
      echo "Missing ssh key files" 1>&2
      exit 1
    fi
    mkdir ~/.ssh
    cp /vagrant/id_rsa ~/.ssh/id_rsa
    cp /vagrant/id_rsa.pub ~/.ssh/id_rsa.pub

    echo ">>>> Install dotfiles"
    if [ ! -d ~/.dotfiles ]; then
        git clone https://github.com/melkio/dotfiles.git ~/.dotfiles
        cd ~/.dotfiles
        sh bootstrap.sh
        git remote rm origin 
        git remote add origin git@github.com:melkio/dotfiles.git
    fi

    echo ">>>> Install asdf and related plugins..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
    source ~/.asdf/asdf.sh

    asdf plugin-add dotnet-core https://github.com/emersonsoares/asdf-dotnet-core.git
    asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
    asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    bash -c '~/.asdf/plugins/nodejs/bin/import-release-team-keyring'

    asdf install dotnet-core 3.1.402 && asdf global dotnet-core 3.1.402
    asdf install nodejs 14.11.0 && asdf global nodejs 14.11.0

#   echo ">>>> Configure gnome terminal"
#   dbus-launch dconf load /org/gnome/terminal/ < /vagrant/config/terminal/gnome-terminal.dconf
HEREDOC

echo ">>>> That's all, rock on!"

reboot
