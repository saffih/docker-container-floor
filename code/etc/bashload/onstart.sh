echo "echo /etc/bashload/hook.sh: skip . /etc/bashload/load.sh" > /etc/bashload/hook.sh

if [ -d /etc/bashload/load.d ]; then
  for i in /etc/bashload/load.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi

echo forground supervisor
/usr/bin/supervisord -n -e debug  -c /etc/supervisord.conf
echo existed supervisor ==> exiting

# trap exit
trap ". /etc/bashload/cmddone.sh" EXIT
