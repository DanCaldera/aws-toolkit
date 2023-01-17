- npm install pm2 -g
- pm2 start app.js
- pm2 status
- pm2 restart app.js
- pm2 logs
- pm2 flush
- pm2 startup amazon | ubuntu
- sudo vim /etc/yum.repos.d/nginx.repo
Enter this there
[nginx]
name=nginx repo
baseurl=https://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1
- cat /etc/os-release 
- sudo yum update
- sudo yum install nginx
- sudo service nginx start
- sudo service nginx stop
- sudo nano /etc/nginx/conf.d