#!/bin/bash

# create script directory
scriptdir=/var/myscripts
scriptfile=copy-file.sh
mkdir -p $scriptdir

# create data directory
datadir=/var/mydata
mkdir -p $datadir
chown -R ec2-user $datadir

# create log directory
logdir=/var/mylogs
logfile=log.txt
mkdir -p $logdir
chown -R ec2-user $logdir

# shell command to sync ec2's data directory with S3 directory (S3 => local folder on ec2)
# space needed after ! to prevent bash history substitution
# shebang may contain space before command
# ${name} is replaced by terraform, $name is ignored and replaced by bash at runtime
# terraform gives an error if there are unknown variables in curly brackets
echo "
#! /bin/bash
set -euo pipefail
aws s3 sync --delete s3://${bucket}/mydata/ $datadir/
" >> $scriptdir/$scriptfile
chmod +x $scriptdir/$scriptfile

# add cron task to sync ec2's data directory with S3 directory, runs every minute under 'ec2-user' account
cronpath=/var/spool/cron/ec2-user
echo "*/1 * * * * /var/myscripts/copy-file.sh" >> $cronpath

# start http server listing all files in <datadir>
# for Python 3: sudo nohup python -m http.server 80 &
echo "Server name: ${server_name}" >> $logdir/$logfile
echo "Starting SimpleHTTPServer ..." >> $logdir/$logfile
nohup python -m SimpleHTTPServer 80 &
echo "... SimpleHTTPServer is running" >> $logdir/$logfile
