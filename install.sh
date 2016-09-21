#!/usr/bin/env sh

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `install.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

cd $(dirname $BASH_SOURCE)
BASE=$(pwd)

echo "💻  Preparing Development Environment..."

# Check if on macOS with uname Darwin
if [ $(uname -s) = 'Darwin' ]; then
  # Check for Homebrew
  if test ! $(which brew); then
    echo "📦  Installing Homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
fi

echo "📥  Installing Homebrew Packages..."
brew bundle --verbose

# Switch to using brew-installed ZSH as default shell
if ! fgrep -q $(command -v zsh) /etc/shells; then
  command -v zsh | sudo tee -a /etc/shells
  chsh -s $(command -v zsh)
fi;

stow -v misc zsh

n latest

apm install --production false --packages-file Atomfile

# Fix autocomp permission
chmod go-w '/usr/local/share'

source ./macOS.sh

echo "😀  Happy Hacking"
