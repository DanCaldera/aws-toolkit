# 

sudo su -

cd /usr/local/bin
mkdir ffmpeg

cd ffmpeg
wget https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.2.1-amd64-static.tar.xz
tar xvf ffmpeg-4.2.1-amd64-static.tar.xz
mv ffmpeg-4.2.1-amd64-static/ffmpeg .

ln -s /usr/local/bin/ffmpeg/ffmpeg /usr/bin/ffmpeg
exit


--------------------------------------------------------------------------------


Create a folder at the root of your app or project called ```.ebextensions```
Inside the folder ```.ebextensions``` create a file called ```01_ffmpeg.config```
Inside this file paste in the below contents:

```
commands:
  command1:
    command: ls
  command2:
    command: "cd /usr/local/bin"
  command3:
    command: "mkdir ffmpeg"
    cwd: /usr/local/bin
    ignoreErrors: true
  command4:
    command: "cd /usr/local/bin/ffmpeg"
  command5:
    command: "wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz"
    cwd: /usr/local/bin/ffmpeg
    ignoreErrors: true
  command6:
    command: "tar -xf ffmpeg-release-amd64-static.tar.xz"
    cwd: /usr/local/bin/ffmpeg
    ignoreErrors: true
  command7:
    command: "ln -sfn /usr/local/bin/ffmpeg/ffmpeg-*-amd64-static/ffmpeg /usr/bin/ffmpeg"
    cwd: /usr/local/bin/ffmpeg
    ignoreErrors: true
  command8:
    command: "ln -sfn /usr/local/bin/ffmpeg/ffmpeg-*-amd64-static/ffprobe /usr/bin/ffprobe"
    cwd: /usr/local/bin/ffmpeg
    ignoreErrors: true
```

4. add the folder and file you just created to your source versioning system via ```git add .ebextensions/```
5. Commit via ```git commit -m "install ffmpeg on AWS"```
6. Deploy to beanstalk via ```eb deploy```

NOTES: Tutorial on syntax for the file - https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/customize-containers-ec2.html