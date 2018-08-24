#!/bin/sh

if [ ! command -v brew &>/dev/null ]; then
  echo "Please install Homebrew first (https://brew.sh)"
  exit 1
fi

function ssh_generate_keys {
  if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Generating new SSH keys";
    ssh-keygen -t rsa;
  else
    echo "Found existing SSH keys"
  fi
}

function brew_install_other () {
  brew tap caskroom/cask
  brew tap caskroom/versions
  brew install bash-completion jq
  brew cask install iterm2 
  brew cask install slack firefox atom
}

ssh_generate_keys

if [ ! brew ls --versions git &>/dev/null ]; then
  echo "Installing Git from Homebrew";
  brew install git;
  echo "Please restart your session and re-run this script";
else
  echo "Installing other packages from Homebrew";
  brew_install_other;
  echo "You're all set to go...";
fi
