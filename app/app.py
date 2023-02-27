from flask import render_template, Flask
import socket

app = Flask(__name__)

@app.route('/')
def index():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(('192.255.255.255', 1))
        ip = s.getsockname()[0]
    except:
        ip = 'unknown'
    finally:
        s.close()
    return render_template('index.html', ip=ip)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port='5000')
