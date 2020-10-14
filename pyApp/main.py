from flask import Flask
from util.constants import HOST, PORT, DEBUG, ENV

app = Flask(__name__)
app.config

if __name__ == '__main__':
    app.run(host=HOST, port=PORT, debug=DEBUG)
