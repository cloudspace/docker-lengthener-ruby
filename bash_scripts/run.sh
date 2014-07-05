#!/bin/bash

if [ ! -f /.setup_finished ]; then
  /setup.sh
fi

touch /.running
echo "[`date`] - Starting Supervisor"
exec supervisord -n