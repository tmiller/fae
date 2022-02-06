# XDG Settings
set --global --export GNUPGHOME $HOME/.config/gnupg

if status is-interactive
  set --global --export GPG_TTY (tty)
  set --global --export SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent
end
