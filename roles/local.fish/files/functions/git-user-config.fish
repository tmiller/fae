function git-user-config --description "Configure user for git locally"
  read --local --prompt-str "Enter your name: " name
  read --local --prompt-str "Enter your email: " email

  set --local signing_key (
    gpg --list-secret-keys $email 2>/dev/null \
    | rg ssb \
    | rg '\[S\]' \
    | awk '{print $2}' \
    | awk -F/ '{print $2}'
  )

  if test -n "$signing_key"
    git config --local user.signingkey $signing_key
    git config --local commit.gpgsign true
  end

  git config --local user.name $name
  git config --local user.email $email
end
