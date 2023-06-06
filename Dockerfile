# start from runpod pytorch container
ARG BASE_IMAGE=runpod/oobabooga:1.1.0
FROM ${BASE_IMAGE} as dev-base

# Working directory
WORKDIR /workspace

# Update, upgrade, and install necessary packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends\
    nano zip unzip libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --no-cache-dir -U \
    rich langchain langflow xformers accelerate einops sentencepiece transformers

ADD start.sh /
RUN chmod +x /start.sh

CMD [ "/start.sh" ]