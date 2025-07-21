#!/bin/bash

set -e  # Exit on error

echo "=== Updating packages ==="
sudo apt update

echo "=== Installing dependencies ==="
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
  libffi-dev liblzma-dev git

echo "=== Installing pyenv ==="
curl https://pyenv.run | bash

# Add pyenv to shell startup (for bash)
if ! grep -q 'pyenv init' ~/.bashrc; then
  echo -e '\n# Pyenv setup' >> ~/.bashrc
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc
fi

# Apply changes to current session
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

echo "=== Installing Python 3.11.4 with pyenv ==="
pyenv install 3.11.4

echo "=== Setting Python 3.11.4 as global version ==="
pyenv global 3.11.4

echo "=== Verifying Python version ==="
python --version

echo "✅ pyenv setup complete. Python 3.11.4 is ready to use."

echo "=== Making virtual environment ==="
python -m venv .venv
source .venv/bin/activate

echo "=== Updating pip and installing requirements ==="
pip install --upgrade pip
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
pip install "numpy<2"
pip install peft transformers datasets scikit-learn huggingface_hub
pip install autohpsearch