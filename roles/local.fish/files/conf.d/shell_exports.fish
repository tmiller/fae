set --global --export EDITOR nvim
set --global --export PAGER less
set --global --export LESS -ingFXRS
set --global --export GOPATH $HOME
set --global --export VAGRANT_DEFAULT_PROVIDER virtualbox
set --global --export KUBECONFIG "$HOME/.kube/config"
set --global --export DOCKER_SCAN_SUGGEST false
set --global --export FZF_DEFAULT_COMMAND $FZF_FIND_FILE_COMMAND

# Setup Path
if test -x /opt/homebrew/bin
  fish_add_path /opt/homebrew/sbin /opt/homebrew/bin
end

# XDG Settings
set --global --export XDG_CACHE_HOME  $HOME/.cache
set --global --export XDG_CONFIG_HOME $HOME/.config
set --global --export XDG_DATA_HOME   $HOME/.local/share
set --global --export XDG_STATE_HOME  $HOME/.local/state
