FROM gitpod/openvscode-server:latest

USER root

RUN apt-get update && apt-get install -y \
    software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y \
    python3.12 \
    python3.12-venv \
    python3-pip \
    curl \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir pipenv

RUN python3.12 -m venv /home/workspace/venv && \
    /home/workspace/venv/bin/pip install --no-cache-dir --upgrade pip

USER openvscode-server

WORKDIR /home/workspace

ENV PIPENV_VENV_IN_PROJECT=1

ENV PATH="/home/workspace/.venv/bin:$PATH"

ENV PYTHONPATH=/home/workspace

COPY . /home/workspace/

EXPOSE 3000

CMD ["code-server", "--bind-addr", "0.0.0.0:3000", "--auth", "none"]

# CMD ["openvscode-server", "--port", "3000", "--host", "0.0.0.0", "--folder", "/home/workspace"]
