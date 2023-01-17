- docker build -t dan/flask-app:v1.0.0 .
- docker images
- docker run -p 5000:5000 --name my-flask dan/flask-app:v1.0.0

* https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html
- df -Th
- lsblk
- sudo growpart /dev/xvda 1
- sudo xfs_growfs -d /

- docker stop bbf
- docker system prune

or just

docker-compose up


To simply run just use this

pm2 start app.py --name audio1 --interpreter python3
