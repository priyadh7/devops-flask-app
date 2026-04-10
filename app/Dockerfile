# ============================================================
# Dockerfile — Phase 2: Containerization
# Base image: python:3.10-slim (lightweight, production-ready)
# ============================================================

# Step 1: Use official slim Python image to keep image size small
FROM python:3.10-slim

# Step 2: Set working directory inside the container
WORKDIR /app

# Step 3: Copy dependency file first (leverages Docker layer caching)
COPY requirements.txt .

# Step 4: Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Copy the rest of the application source code
COPY . .

# Step 6: Expose port 5000 (Flask default port)
EXPOSE 5000

# Step 7: Run the app using Gunicorn (production WSGI server)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
