#! /usr/bin/env bash

HOME="/home/nmvega"

# ==================================================================
# IMPORTANT IMPORTANT IMPORTANT IMPORTANT IMPORTANT IMPORTANT 
# ==================================================================
# If the Python package - 'pyright(1)' command - is found in the
# Bash PATH, the ":MasonInstallAll" command below will not install
# it in neovim (and we always want it to)! So, temporarily deactivate(1)
# the current Python 'venv', as well as 'dnf(1) remove pyright' (if
# it exists). In the end, we're ensuring that the command -
# nmvega$ which pyright - returns nothing prior to running this script.
# ==================================================================


# ==================================================================
# STEP-1: PURGE PREVIOUS INSTALLATION
# ==================================================================
cd ${HOME}
[ x"${?}" != x"0" ] && echo "exit 1" && exit 1
cp -rp ${HOME}/.config/nvim/.git ${HOME}/.git.$$ # Save & later restore '.../.git' directory.
rm -rf ${HOME}/.cache/nvim ${HOME}/.local/share/nvim ${HOME}/.local/state/nvim ${HOME}/neovim-python
rm -rf ${HOME}/.config/nvim
# ==================================================================


# ==================================================================
# STEP-2: Start clean with NvChad starter installation.
# ==================================================================
git clone -b v2.0 https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
rm -rf ${HOME}/.config/nvim/.git* ${HOME}/.config/nvim/LICENSE
/usr/bin/nvim # Let the plugins install; Then select 'Nightowl' color-scheme (w/ sp + th); Then quit.
/usr/bin/nvim -c "MasonInstallAll"
# ==================================================================


# ==================================================================
# STEP-3: Integrate this GitHub REPO's to add Python IDE features.
# YouTube Step-by-Step: https://www.youtube.com/watch?v=4BnVeOUeZxc
# ==================================================================
cd ${HOME}
[ x"${?}" != x"0" ] && echo "exit 1" && exit 1
git clone https://github.com/dreamsofcode-io/neovim-python.git
cd ${HOME}/neovim-python/ && rm -rf .git* && find . | cpio -puvdm ${HOME}/.config/nvim/lua/custom
cd ${HOME} && rm -rf ${HOME}/neovim-python
/usr/bin/nvim -c "TSInstall python" # Install Python Plugins.
# ==================================================================


# ==================================================================
# STEP-4: ruff(1) is replacing the now-depracated "ruff_lsp", so
# the following dnf(1) and in-line edits are necessary.
# ==================================================================
sudo dnf -y install ruff
sed -i -e 's/"ruff-lsp"/"ruff"/' ${HOME}/.config/nvim/lua/custom/plugins.lua
sed -i -e 's/"ruff_lsp"/"ruff"/' ${HOME}/.config/nvim/lua/custom/configs/lspconfig.lua
# ==================================================================

# ==================================================================
# Step-5: Run these commands again.
# ==================================================================
/usr/bin/nvim -c "TSInstall python" -c "MasonInstallAll" # Make sure! Check w/: ':LspInfo'
# ==================================================================

# ==================================================================
# Restore '.git/' sub-directory, as we as this (possibly) modified script.
# ==================================================================
mv ${HOME}/.git.$$ ${HOME}/.config/nvim/.git
(cd ${HOME}/.config/nvim/ && \
   git remote set-url origin git@github.com:nmvega/neovim-nvchad-python-config.git)
cp $(realpath "$0") ${HOME}/.config/nvim/ # Restore this script too.
# ==================================================================
