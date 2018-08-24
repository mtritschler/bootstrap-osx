#!/bin/bash

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

function brew_tap_casks () {
  brew tap caskroom/cask
  brew tap caskroom/versions
}

function brew_install_base () {
  brew install bash-completion jq
  brew cask install iterm2
  brew cask install slack firefox atom 1password
}

function brew_install_devtools () {
  brew cask install java8
  brew install maven maven-completion gradle gradle-completion scala sbt
  brew cask install intellij-idea-ce
}

function print_usage() {
  echo "This script bootstraps a new machine with SSH keys and some elementary packages"
  echo "Usage:\n./install.sh [OPTIONS]\n"
  echo "Options:"
  echo "\t--devtools\tInstalls Java, Scala, build tools and IntelliJ"

}

INSTALL_DEVTOOLS=NO
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --devtools)
    INSTALL_DEVTOOLS=YES
    shift
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
  esac
done

ssh_generate_keys

if [ ! brew ls --versions git &>/dev/null ]; then
  echo "Installing Git from Homebrew";
  brew install git;
  echo "Please restart your session and re-run this script";
else
  echo "Tapping Homebrew casks"
  brew_tap_casks;

  echo "Installing base packages from Homebrew";
  brew_install_base;

  if [ "$INSTALL_DEVTOOLS" == "YES" ]; then
    echo "Installing developer tools";
    brew_install_devtools;
  fi

  echo "You're all set to go...";
fi
