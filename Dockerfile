FROM gitpod/openvscode-server:latest

# Switch to root for system installations
USER root

# Update repository and add deadsnakes PPA for Python 3.12
RUN apt-get update && apt-get install -y \
    software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
    python3.12 \
    python3.12-venv \
    python3-pip \
    curl \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

# Install pipenv globally
RUN pip3 install --no-cache-dir pipenv

# Set up a Python virtual environment
RUN python3.12 -m venv /home/workspace/venv && \
    /home/workspace/venv/bin/pip install --no-cache-dir --upgrade pip

# Switch back to openvscode-server user
USER openvscode-server

# Set working directory
WORKDIR /home/workspace

# Add the virtual environment to PATH
ENV PATH="/home/workspace/venv/bin:$PATH"

# Install dependencies
COPY requirements.txt /home/workspace/
RUN pipenv install --dev --ignore-pipfile

# Copy application code
COPY . /home/workspace/

# Expose port and start VSCode server
EXPOSE 3000
CMD ["code-server", "--bind-addr", "0.0.0.0:3000", "--auth", "none"]




# FROM gitpod/openvscode-server:latest

# # Switch to root to perform system-level installations
# USER root

# # Install dependencies and Python 3.12
# RUN apt-get update && apt-get install -y \
#     software-properties-common \
#     && add-apt-repository ppa:deadsnakes/ppa \
#     && apt-get update && apt-get install -y \
#     python3.12 \
#     python3.12-venv \
#     python3-pip \
#     curl \
#     build-essential \
#     && rm -rf /var/lib/apt/lists/*

# # Install pipenv globally in the root environment (outside virtualenv)
# RUN pip3 install --no-cache-dir pipenv

# # Create the virtual environment in the workspace
# RUN python3.12 -m venv /home/workspace/venv

# # Upgrade pip inside the virtual environment to ensure we have the latest version
# RUN /home/workspace/venv/bin/pip install --no-cache-dir --upgrade pip

# # Switch to the openvscode-server user to run the application
# USER openvscode-server

# # Set working directory
# WORKDIR /home/workspace

# # Ensure the virtual environment is used by adding it to the PATH
# ENV PATH="/home/workspace/venv/bin:$PATH"

# # Install dependencies using pipenv (using the virtual environment)
# COPY requirements.txt /home/workspace/
# RUN pipenv install --dev --ignore-pipfile

# # Copy the rest of the application code
# COPY . /home/workspace/

# # Expose the port for VSCode server
# EXPOSE 3000

# # Start the VSCode server
# CMD ["code-server", "--bind-addr", "0.0.0.0:3000", "--auth", "none"]
# CMD ["openvscode-server", "--port", "3000", "--host", "0.0.0.0", "--folder", "/home/workspace"]
