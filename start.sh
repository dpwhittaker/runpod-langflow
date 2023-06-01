#!/bin/bash

echo 'syncing to workspace, please wait'

CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 pip install llama-cpp-python --force-reinstall --no-cache-dir

if [[ $PUBLIC_KEY ]]
then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    cd ~/.ssh
    echo $PUBLIC_KEY >> authorized_keys
    chmod 700 -R ~/.ssh
    cd /
    service ssh start
fi

cd /workspace/text-generation-webui/models

if [ ! -f guanaco-65B.ggmlv3.q8_0.bin ]; then
    wget https://huggingface.co/TheBloke/guanaco-65B-GGML/resolve/main/guanaco-65B.ggmlv3.q8_0.z01
    wget https://huggingface.co/TheBloke/guanaco-65B-GGML/resolve/main/guanaco-65B.ggmlv3.q8_0.zip
    zip -FF guanaco-65B.ggmlv3.q8_0.zip --out guanaco-65B.ggmlv3.q8_0.full
    rm guanaco-65B.ggmlv3.q8_0.z*
    unzip guanaco-65B.ggmlv3.q8_0.full
    rm guanaco-65B.ggmlv3.q8_0.full
fi


if [[ $JUPYTER_PASSWORD ]]
then
  echo "Launching Jupyter Lab"
  cd /
  nohup jupyter lab --allow-root --no-browser --port=8888 --ip=* --ServerApp.token=$JUPYTER_PASSWORD --ServerApp.allow_origin=* --ServerApp.preferred_dir=/workspace &
fi

echo "Launching Server"
cd /workspace/text-generation-webui

python server.py --listen --chat --n-gpu-layers 128 --threads 1 --model guanaco-65B.ggmlv3.q8_0.bin

sleep infinity