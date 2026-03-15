#!/bin/bash
# set -eux

CUSTOM_NODES_CONF="./custom-nodes.conf"

export COMFYUI="${COMFYUI_INSTALL_DIR:-/opt}/ComfyUI"

if [[ ! -d "${COMFYUI}" ]]; then
	echo "Installing ComfyUI to ${COMFYUI}, this might take a while"

    git clone https://github.com/comfyanonymous/ComfyUI.git "${COMFYUI}"

    while IFS="|" read -r url recursive || [[ -n "$url" ]]; do
        [[ -z "$url" || "$url" =~ ^# ]] && continue

        url=$(echo "$url" | xargs)
        repo_name=$(basename "$url" .git)
        recursive=$(echo "$recursive" | xargs)

        target_path="${COMFYUI}/custom_nodes/$repo_name"

        GIT_CMD="git clone --depth 1"
        [ "$recursive" == "y" ] && GIT_CMD="$GIT_CMD --recursive"

        $GIT_CMD "$url" "$target_path"
    done < "$CUSTOM_NODES_CONF"

    # wget "https://github.com/comfyanonymous/ComfyUI_examples/blob/master/flux/flux_dev_example.png" \
    #     -P "${COMFYUI}"

    # mkdir -p "${COMFYUI}/models/ultralytics/bbox"
    # wget "https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt?download=true" \
    #     -O "${COMFYUI}/models/ultralytics/bbox/face_yolov8m.pt"

    # mkdir -p "${COMFYUI}/models/insightface"
    # wget "https://huggingface.co/ezioruan/inswapper_128.onnx/resolve/main/inswapper_128.onnx?download=true" \
    #     -O "${COMFYUI}/models/insightface/inswapper_128.onnx"

    # mkdir -p "${COMFYUI}/models/checkpoints"
    # wget "https://huggingface.co/Comfy-Org/stable-diffusion-v1-5-archive/resolve/main/v1-5-pruned-emaonly-fp16.safetensors?download=true" \
    #     -O "${COMFYUI}/models/checkpoints/v1-5-pruned-emaonly-fp16.safetensors"

    # echo "Syncing custom workflows and input assets..."

    mkdir -p "${COMFYUI}/user/default/workflows"
    cp -r workflows/* "${COMFYUI}/user/default/workflows/"
    chmod -R 644 "${COMFYUI}/user/default/workflows/"

    # cp comfy.settings.json "${COMFYUI}/user/default/comfy.settings.json"
    # chmod 644 "${COMFYUI}/user/default/comfy.settings.json"

    mkdir -p "${COMFYUI}/input"
    cp assets/*.png "${COMFYUI}/input/"
    cp assets/*.mp4 "${COMFYUI}/input/"
    cp assets/*.mp3 "${COMFYUI}/input/"
    chmod -R 644 "${COMFYUI}/input/"

    # cp defaultGraph.json /defaultGraph.json
    # chmod 644 /defaultGraph.json

    # cp replaceDefaultGraph.py /replaceDefaultGraph.py
    # chmod 755 /replaceDefaultGraph.py

    # cp defaultGraph.json "${COMFYUI}/web/templates/default.json"
    # chmod 644 "${COMFYUI}/web/templates/default.json"
fi

pip install --no-cache-dir --upgrade-strategy only-if-needed \
    -r "${COMFYUI}/requirements.txt" \
    einops==0.8.0 \
    sageattention==1.0.6

# cd "${COMFYUI}/custom_nodes"
python "${COMFYUI}/custom_nodes/x-flux-comfyui/setup.py"
python "${COMFYUI}/custom_nodes/ComfyUI-Impact-Pack/install.py"
python "${COMFYUI}/custom_nodes/ComfyUI-Frame-Interpolation/install.py"

# Default graph handling
# python3 /replaceDefaultGraph.py

# VibeVoice note: to pin transformers if needed, uncomment below line
# pip install transformers==4.49.0

# Link /ComfyUI folder to /workspace so it's available in that familiar location as well
# ln -s "${COMFYUI}" /ComfyUI
