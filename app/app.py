# ============================================================
# app.py - Flask Web Application Entry Point
# Phase 2: Containerization | DevOps Project
# ============================================================

from flask import Flask, render_template, request

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    output = None
    if request.method == "POST":
        user_input = request.form.get("user_input", "").strip()
        # Simple echo logic — focus is on DevOps, not app complexity
        output = f"You entered: {user_input.upper()}"
    return render_template("index.html", output=output)

if __name__ == "__main__":
    # Run on 0.0.0.0 so it's accessible inside Docker container
    app.run(host="0.0.0.0", port=5000, debug=False)
