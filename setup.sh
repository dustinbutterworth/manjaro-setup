#!/usr/bin/env -S zsh -e

# Cleaning the TTY.
clear

print () {
    echo -e "\e[1m\e[93m[ \e[92m•\e[93m ] \e[4m$1\e[0m"
}

print "What's your shodan api key?"
read SHODANKEY


print "What's your hostio api key?"
read HOSTIOKEY


print "What's your IBM X-Force Exchange api key?"
read IBMKEY


print "Updating system."
sudo pacman -Syyu

print "Install packages from pkglist.txt."
sudo pacman -S --needed base-devel openssl zlib xz
sudo pacman -S --needed - < pkglist.txt


print "Enabling snapd"
sudo systemctl enable --now snapd.socket
sudo systemctl start snapd


print "zsh setup"
touch ~/.zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i 's/robbyrussell/agnoster/g' ~/.zshrc


print "pyenv setup - bash"
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc


print "pyenv setup - zsh"
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc


print "pyenv installing python shims"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"    # if `pyenv` is not already on PATH
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
pyenv install $(python --version | awk '{print $2}')


print "Installing Ultimate vimrc"
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh


print "Setting up snap path"
echo "# SNAP PATH"
echo 'export PATH="$PATH:/snap/bin"' 
export PATH="$PATH:/snap/bin"


print "Installing Azure cli (just accept all default options)"
curl -s -L https://aka.ms/InstallAzureCli | bash
echo "# Azure CLI"
echo 'export PATH=$PATH:/home/burt/bin' >> ~/.zshrc
echo "source '/home/burt/lib/azure-cli/az.completion'" >> ~/.zshrc


print "Installing aws cli"
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


print "Intalling feroxbuster"
curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/master/install-nix.sh | bash
sudo mv feroxbuster /usr/bin/


print "Setting up GOPATH"
echo '# GOPATH' >> ~/.zshrc
echo 'export PATH="$PATH:$HOME/go/bin"' >> ~/.zshrc
export PATH="$PATH:$HOME/go/bin"


print "Installing assetfinder"
go install github.com/tomnomnom/assetfinder@latest


print "Installing amass"
sudo snap install amass


print "Installing subjack"
go install github.com/haccer/subjack@latest


print "Installing httprobe"
go install github.com/tomnomnom/httprobe@latest


print "Intalling gf"
go install github.com/tomnomnom/gf@latest
mkdir ~/.gf
cp ~/go/pkg/mod/github.com/tomnomnom/gf*/examples/*.json ~/.gf


print "Installing meg"
go install github.com/tomnomnom/meg@latest


print "Installing Aquatone"
wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
unzip aquatone_linux_amd64_1.7.0.zip
sudo mv aquatone /usr/bin


print "Installing shodan"
pip install -U shodan
shodan init $SHODANKEY


print "Installing powershel (Not officially supported!)"
# Clone the AUR package down with git, use the "Git Clone URL"
git clone https://aur.archlinux.org/powershell-bin.git
makepkg -si ./powershell-bin


print "Installing Azure Powershell module"
pwsh -c "Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force"


print "Setting up some aliases and functions I like"
curl -s https://raw.githubusercontent.com/dustinbutterworth/recon_profile/master/.bash_profile | sed 's/$HOSTIO_KEY/'$HOSTIOKEY'/g' | sed 's/$IBM-API-KEY/'$IBMKEY'/g' >> ~/.zshrc

