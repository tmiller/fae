function gpg-update-yubikey --description "Update the yubikey for gpg-agent"
  command gpg-connect-agent "scd serialno" "learn --force" /bye
end
