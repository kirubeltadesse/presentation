# Use a base image that includes Python
FROM python:3.9

# Install wget and unzip
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install Pandoc binary
RUN wget https://github.com/jgm/pandoc/releases/download/2.14/pandoc-2.14-linux-arm64.tar.gz \
    && tar -xzf pandoc-2.14-linux-arm64.tar.gz -C /usr/local \
    && rm pandoc-2.14-linux-arm64.tar.gz

# Add the Pandoc binary to the PATH
ENV PATH="/usr/local/pandoc-2.14/bin:${PATH}"

# Install pip upgrade
RUN pip install --upgrade pip

# Install the required Python packages from the requirements file
COPY requirements*.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements-dev.txt

# Set the working directory
WORKDIR /presentation

# Set the default command to tail the logs (you can override this if needed)
# CMD ["tail", "-f", "/dev/null"]

# Start the HTTP server to serve the slides
CMD ["python3", "-m", "http.server", "8000", "--directory", "build"]
