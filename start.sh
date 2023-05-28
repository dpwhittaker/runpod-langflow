#!/bin/bash

echo 'syncing to workspace, please wait'

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

cd /workspace/text-generation-webui/

if [ ! -z "$LOAD_MODEL" ] && [ "$LOAD_MODEL" != "TheBloke/guanaco-65B-GGML" ]; then
    rm -rf /workspace/text-generation-webui/models/guanaco*
    python /workspace/text-generation-webui/download-model.py $LOAD_MODEL
fi

if [[ $JUPYTER_PASSWORD ]]
then
  echo "Launching Jupyter Lab"
  cd /
  nohup jupyter lab --allow-root --no-browser --port=8888 --ip=* --ServerApp.token=$JUPYTER_PASSWORD --ServerApp.allow_origin=* --ServerApp.preferred_dir=/workspace &
fi

echo "Launching Server"
cd /workspace/text-generation-webui
#python server.py --listen # runs Oobabooga text generation webui on port 7860
if [ "$WEBUI" == "chatbot" ]; then
    python server.py --listen --cai-chat
else
    python server.py --listen
fi

sleep infinity