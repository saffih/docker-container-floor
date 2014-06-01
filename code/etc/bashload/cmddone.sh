
if [ -d /etc/bashload/unload.d ]; then
  for i in /etc/bashload/unload.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi
