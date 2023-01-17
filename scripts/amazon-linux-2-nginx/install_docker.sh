sudo yum update
sudo yum search docker
sudo yum info docker
sudo yum install docker
sudo usermod -a -G docker ec2-user
id ec2-user
sudo pip3 install docker-compose
# or
# wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
# sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
# sudo chmod -v +x /usr/local/bin/docker-compose
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo systemctl status docker.service
docker version
docker-compose version
