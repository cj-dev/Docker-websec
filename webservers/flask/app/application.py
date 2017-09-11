from flask import Flask, render_template
import os

app = Flask(__name__)
if os.environ['APPLICATION_ROLE'] == 'evil':
    app.config.from_object('config.EvilConfig')
else:
    app.config.from_object('config.LegitConfig')

@app.route('/')
def index():
    if app.config['EVIL']:
        return render_template('evil_index.html')
    else: return render_template('legit_index.html')

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')
