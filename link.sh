#! /bin/bash
if [[ $UID != 0 ]]; then
  echo "This script requires root"
  exit $1
fi

for rule in ./*.rules; do
  dest="/etc/udev/rules.d/$rule"
  if [[ -f "$dest" ]]; then
    echo "WARN: $dest exists and is not a symlink, skipping"
    continue
  fi
  if [[ -L "$dest" ]]; then
    echo "$dest exists as symlink, removing"
    rm $dest
  fi
  echo "Symlinking $rule to $dest"
  ln -s $(pwd)/$rule $dest
done

udevadm control --reload-rules
udevadm trigger