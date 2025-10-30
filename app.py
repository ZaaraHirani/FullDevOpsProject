from flask import Flask, abort
import os
import signal

app = Flask(__name__)
is_healthy = True

@app.route('/')
def hello():
    return "Hello! This is the dummy app. I am healthy."

@app.route('/health')
def health_check():
    if is_healthy:
        return "OK", 200
    else:
        return "Service Unavailable", 503

@app.route('/break')
def break_app():
    global is_healthy
    is_healthy = False
    return "App is now marked as unhealthy!", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
