#!/bin/bash

# create script directory
scriptdir=/var/myscripts
scriptfile=generate-file.sh
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

# shell command to generate a new file and upload it to S3 folder
echo '''
#!/bin/bash
set -euo pipefail
echo "Hello World!" > "/var/mydata/$(date +"%Y-%m-%d_%T.txt")"
aws s3 cp --recursive /var/mydata/ s3://tfs3polling-094033154904-eu-west-1/mydata/
rm -rf /var/mydata/*
''' >> $scriptdir/$scriptfile
chmod +x $scriptdir/$scriptfile

# add cron task to generate a new file, runs every five minutes under 'ec2-user' account
cronpath=/var/spool/cron/ec2-user
echo "*/5 * * * * /var/myscripts/generate-file.sh" >> $cronpath

# start http server listing all files in <datadir>
# for Python 3: sudo nohup python -m http.server 80 &
echo "Server name: ${server_name}" >> $logdir/$logfile
echo "Starting SimpleHTTPServer ..." >> $logdir/$logfile
nohup python -m SimpleHTTPServer 80 &
echo "... SimpleHTTPServer is running" >> $logdir/$logfile
