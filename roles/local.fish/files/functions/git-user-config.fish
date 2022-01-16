function git-user-config --description "Configure user for git locally"
  read --local --prompt-str "Enter your name: " name
  read --local --prompt-str "Enter your email: " email

  git config --local user.name $name
  git config --local user.email $email
end
