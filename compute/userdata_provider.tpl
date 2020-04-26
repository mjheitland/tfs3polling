#!/bin/bash

# yum install httpd -y
# echo "Server number: ${server_name}" >> /var/www/html/index.html
# service httpd start
# chkconfig httpd on

# sudo mkdir -p /var/www/html
# cd /var/www/html
# sudo echo "Server name: ${server_name}" >> /var/www/html/index.html
# sudo echo "Starting SimpleHTTPServer ..." >> /var/www/html/SimpleHTTPServer-log.txt
# sudo nohup python -m SimpleHTTPServer 80 &
# # for Python 3: sudo nohup python -m http.server 80 &
# sudo echo "... SimpleHTTPServer is running" >> /var/www/html/SimpleHTTPServer-log.txt

# create script directory
scriptdir=/var/myscripts
scriptfile=generate-file.sh
mkdir -p $scriptdir

# create data directory
datadir=/var/mydata
logfile=log.txt
mkdir -p $datadir
chown -R ec2-user $datadir

# shell command to generate a new file
echo '''
#!/bin/bash
set -euo pipefail
echo "Hello World!" > "/var/mydata/$(date +"%Y-%m-%d_%T.txt")"
''' >> $scriptdir/$scriptfile
chmod +x $scriptdir/$scriptfile

# add cron task to generate a new file, runs every minute under 'ec2-user' account
cronpath=/var/spool/cron/ec2-user
echo "*/1 * * * * /var/myscripts/generate-file.sh" >> $cronpath

# start http server listing all files in <datadir>
echo "Server name: ${server_name}" >> $datadir/$logfile
echo "Starting SimpleHTTPServer ..." >> $datadir/$logfile
nohup python -m SimpleHTTPServer 80 &
echo "... SimpleHTTPServer is running" >> $datadir/$logfile
