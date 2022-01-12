function op --wraps op --description "1password command that will log in if necessary"
  if set --query op_session[1]; and test -n "$op_session"
    set session_flag --session $op_session
  end

  set --universal op_session (command op --cache $session_flag signin my --raw)
  command op --session $op_session --cache $argv
end
