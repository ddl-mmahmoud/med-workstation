#!/bin/bash

_clone () {
  local where="$1"
  local what="$2"
  [ -d "$HOME/deploy/$what" ] || (cd "$HOME/deploy" && git clone "git@github.com:$where/$what")
}

set -ex

[ -d "$HOME/.pyenv" ] || curl -fsSL "https://pyenv.run" | bash -x
(which tsh) || curl -fsSL "https://cdn.teleport.dev/install.sh" | bash -x -s 18.1.4
(which helm) || curl -fsSL "https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3" | bash -x
(which kubectl) || curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" | sudo tee /usr/local/bin/kubectl >/dev/null
sudo chmod +x /usr/local/bin/kubectl

[ -s "$HOME/.ssh/github" ] || ssh-keygen -f "$HOME/.ssh/github" -P "" -t ed25519

mkdir -p deploy
cd deploy

_clone medthehatta config
config/git/_deploy
config/bash/_deploy
config/tmux/_deploy
config/vim/_deploy || true  # fix for .Vundle dir not being checked
echo "$HOME/deploy/config/bash" > "$HOME/.bashrcdir"

_clone ddl-mmahmoud med-workstation

_clone ddl-mmahmoud scratch
_clone ddl-mmahmoud scripts
_clone ddl-mmahmoud misc

_clone ddl-mmahmoud selenium-vm

cd
ln -sf "$HOME/deploy/scratch" "$HOME/_s"
ln -sf "$HOME/deploy/internal-e2e-tests-service" "$HOME/_tests"

"$HOME/deploy/misc/binify" "$HOME/deploy/misc/binify"
binify "$HOME/deploy/scripts/dep"
binify "$HOME/deploy/misc/mkargs"
binify "$HOME/deploy/misc/unroll"
binify "$HOME/deploy/misc/domclone"
