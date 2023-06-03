# start from runpod pytorch container
ARG BASE_IMAGE=nvcr.io/nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04
FROM ${BASE_IMAGE} as dev-base

# Working directory
WORKDIR /workspace

# Set necessary environment variables
ENV DEBIAN_FRONTEND=noninteractive\
    SHELL=/bin/bash\
    PATH="/root/.local/bin:$PATH"

# Update, upgrade, and install necessary packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends\
    bash nano zip unzip git wget curl libgl1 software-properties-common openssh-server python3.10-dev python3.10-venv libpq-dev && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    ln -s /usr/bin/python3.10 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py | python && \
    rm -f get-pip.py

# Install Python packages
RUN pip install --no-cache-dir -U torch torchvision torchaudio pytorch jupyterlab ipywidgets jupyter-archive jupyter_contrib_nbextensions \
    rich langchain langflow xformers accelerate einops sentencepiece transformers accelerate && \
    jupyter nbextension enable --py widgetsnbextension

RUN cd /workspace && git clone https://github.com/oobabooga/text-generation-webui.git && cd /workspace/text-generation-webui && pip install -r requirements.txt

ADD start.sh /
RUN chmod +x /start.sh

CMD [ "/start.sh" ]