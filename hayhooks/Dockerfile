# Use Python base image
FROM deepset/hayhooks:main

# Set working directory
WORKDIR /app

# Copy requirements.txt first for better Docker layer caching
COPY requirements.txt .

# Install Python dependencies using uv in the virtual environment
RUN pip install -r requirements.txt

# Copy all Python files from current directory and subdirectories
COPY . .

# Run the application
CMD ["hayhooks", "run", "--host", "0.0.0.0"]