# configure root user password
if [ "$root_pw" == "" ]; then
  echo 'root:$(pwgen -s 12 1)'|chpasswd
else
  echo "root:$root_pw"|chpasswd
fi 
