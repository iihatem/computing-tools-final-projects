import os
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def index():
    return jsonify({
        "message": "Deployed by Jenkins + Terraform — auto-triggered by SCM poll",
        "build": os.getenv("BUILD_NUMBER", "local"),
    })

@app.route("/health")
def health():
    return jsonify({"status": "ok"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
