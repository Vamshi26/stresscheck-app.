from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

STRESS_KEYWORDS = ["tired", "anxious", "worried", "overwhelmed", "angry"]

def detect_stress(text):
    text = text.lower()
    score = sum(word in text for word in STRESS_KEYWORDS)
    if score >= 3:
        return "High Stress"
    elif score == 2:
        return "Moderate Stress"
    else:
        return "Low Stress"

@app.route("/api/check_stress", methods=["POST"])
def check_stress():
    data = request.get_json()
    text = data.get("text", "")
    level = detect_stress(text)
    return jsonify({"stress_level": level, "input_text": text})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
