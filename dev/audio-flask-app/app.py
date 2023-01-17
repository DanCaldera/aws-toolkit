import os
from uuid import uuid4
from flask import Flask, request, redirect
from pydub import AudioSegment

app = Flask(__name__)
app.secret_key = "super secret key"

cwd = os.getcwd()

# ALLOWED_EXTENSIONS = {'aac', 'ogg', 'midi', 'mpeg', 'wav'}
UPLOAD_FOLDER = '/'


# def allowed_file(filename):
#     return '.' in filename and \
#            filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# elif file and allowed_file(file.filename):


@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            print('No file part')
            return redirect('/')

        file = request.files['file']

        if file.filename == '':
            print('No selected file')
            return redirect('/')
        elif file and file.filename.rsplit('.', 1)[1].lower() == 'mp3':
            # If is mp3 no need to convert
            file.save(str(uuid4()) + '.mp3')
            return redirect('/')
        elif file and 'audio' in file.mimetype:
            try:
                song = AudioSegment.from_file(file)
                # Save Converted File
                song.export(cwd + '/' + str(uuid4()) + ".mp3", format="mp3")
                return redirect('/')
            except Exception as e:
                print(e)
                # Save Original File
                file.save(str(uuid4()) + '.' + file.filename.rsplit('.', 1)[1])
                return redirect('/')
        else:
            print('File type not allowed')
            return redirect('/')
    return '''
    <!doctype html>
    <body style="background-color:black;">
        <title">Audio Conversor (Drop)</title>
        <h1 style="color:white;">Audio Conversor</h1>
        <form method=post enctype=multipart/form-data>
        <input style="color:white;" type=file name=file>
        <input type=submit value=Upload>
        </form>
    </body>
    '''


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=3000)
