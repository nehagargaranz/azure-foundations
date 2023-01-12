# WSL 2 onboarding

This documentation is intended to facilitate the onboarding of developers with Windows 10 workstations

## Pre-requisite
- **Windows 10, updated to version 2004, Build 19041 or higher**
- Ensure [Hyper-V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v) is enabled
- Administrator access of the workstation

## Instructions
1. Install WSL and change the default WSL version to 2 following [this guide](https://docs.microsoft.com/en-us/windows/wsl/install-win10#update-to-wsl-2)
2. Install [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop) and change the settings to [enable WSL 2 integration](https://docs.docker.com/docker-for-windows/wsl/)
3. Choose a Linux distribution (e.g. Ubuntu-20.04 LTS) from Microsoft Store and complete its setup
4. Install other tools mentioned in [Contributing](./contributing###Tools), depending on the chosen distributions, Git and GNU Make may be already installed

### Optional Steps
- Install [Homebrew](https://docs.brew.sh/Homebrew-on-Linux) on WSL 2
- Install [Remote - WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) extension on VS Code
- Add VS Code to path so `code <folder>` in WSL can open the folder with VS Code, details can be found [here](https://code.visualstudio.com/docs/remote/wsl)
- To use `sudo` without password, edit sudoers configurations `sudo visudo` or `sudo vim /etc/sudoers`, make sure it contains `%sudo ALL=(ALL:ALL) NOPASSWD: ALL`
