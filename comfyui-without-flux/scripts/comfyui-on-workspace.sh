#!/bin/bash
set -eux


NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager.git"
    "https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git"
    "https://github.com/XLabs-AI/x-flux-comfyui.git"
    "https://github.com/flowtyone/ComfyUI-Flowty-LDSR.git"
    "https://github.com/kijai/ComfyUI-SUPIR.git"
    "https://github.com/kijai/ComfyUI-KJNodes.git"
    "https://github.com/rgthree/rgthree-comfy.git"
    "https://github.com/JPS-GER/ComfyUI_JPS-Nodes.git"
    "https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes.git"
    "https://github.com/Jordach/comfy-plasma.git"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git"
    "https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait.git"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack.git"
    "https://github.com/ltdrdata/ComfyUI-Impact-Subpack"
    "https://github.com/Fannovel16/comfyui_controlnet_aux.git"
    "https://github.com/ssitu/ComfyUI_UltimateSDUpscale --recursive"
    "https://github.com/yolain/ComfyUI-Easy-Use.git"
    "https://github.com/kijai/ComfyUI-Florence2.git"
    "https://github.com/WASasquatch/was-node-suite-comfyui.git"
    "https://github.com/theUpsider/ComfyUI-Logic.git"
    "https://github.com/cubiq/ComfyUI_essentials.git"
    "https://github.com/chrisgoringe/cg-image-picker.git"
    "https://github.com/chflame163/ComfyUI_LayerStyle.git"
    "https://github.com/shadowcz007/comfyui-mixlab-nodes.git"
    "https://codeberg.org/Gourieff/comfyui-reactor-node.git"
    "https://github.com/chrisgoringe/cg-use-everywhere.git"
    "https://github.com/kijai/ComfyUI-CogVideoXWrapper.git"
    "https://github.com/kijai/ComfyUI-WanVideoWrapper.git"
    "https://github.com/kijai/ComfyUI-MelBandRoFormer.git"
    "https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git"
    "https://github.com/Enemyx-net/VibeVoice-ComfyUI.git"
    "https://github.com/kijai/ComfyUI-segment-anything-2.git"
    "https://github.com/GACLove/ComfyUI-VFI.git"
    "https://github.com/Lightricks/ComfyUI-LTXVideo.git"
    "https://github.com/Fictiverse/ComfyUI_Fictiverse.git"
)

export WORKSPACE="/workspace"
export PYTHONLIBS="${WORKSPACE}/pythonlibs"
export PYTHONPATH="${PYTHONPATH:-}:${PYTHONLIBS}"
export COMFYUI="${WORKSPACE}/ComfyUI"


if [[ ! -d "${COMFYUI}" ]]; then
	echo "Installing ComfyUI to ${WORKSPACE}, this might take a while"

    mkdir -p "${COMFYUI}/input" \
         "${COMFYUI}/models/ultralytics/bbox" \
         "${COMFYUI}/models/insightface" \
         "${COMFYUI}/models/checkpoints" \
         "${COMFYUI}/user/default/workflows"
	
    git clone https://github.com/comfyanonymous/ComfyUI.git "${COMFYUI}"

	cd "${COMFYUI}/custom_nodes"
    for repo in "${NODES[@]}"; do
        if [[ "$repo" == *"UltimateSDUpscale"* ]]; then
            git clone --recursive "$repo"
        else
            git clone "$repo"
        fi
    done

    wget "https://github.com/comfyanonymous/ComfyUI_examples/blob/master/flux/flux_dev_example.png" \
        -P "${COMFYUI}"
    
    wget "https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt?download=true" \
        -O "${COMFYUI}/models/ultralytics/bbox/face_yolov8m.pt"
    
    wget "https://huggingface.co/ezioruan/inswapper_128.onnx/resolve/main/inswapper_128.onnx?download=true" \
        -O "${COMFYUI}/models/insightface/inswapper_128.onnx"
    
    wget "https://huggingface.co/Comfy-Org/stable-diffusion-v1-5-archive/resolve/main/v1-5-pruned-emaonly-fp16.safetensors?download=true" \
        -O "${COMFYUI}/models/checkpoints/v1-5-pruned-emaonly-fp16.safetensors"

    echo "Syncing custom workflows and input assets..."

    cp -r /workflows/* "${COMFYUI}/user/default/workflows/"
    chmod -R 644 "${COMFYUI}/user/default/workflows/"
    
    cp /comfy.settings.json "${COMFYUI}/user/default/comfy.settings.json"
    chmod 644 "${COMFYUI}/user/default/comfy.settings.json"

    cp *.png "${COMFYUI}/input/"
    cp *.mp4 "${COMFYUI}/input/"
    cp *.mp3 "${COMFYUI}/input/"
    chmod -R 644 "${COMFYUI}/input/"

    cp defaultGraph.json /defaultGraph.json
    chmod 644 /defaultGraph.json

    cp replaceDefaultGraph.py /replaceDefaultGraph.py
    chmod 755 /replaceDefaultGraph.py

    cp defaultGraph.json "${COMFYUI}/web/templates/default.json"
    chmod 644 "${COMFYUI}/web/templates/default.json"
fi

if [[ ! -d "${PYTHONLIBS}" ]]; then
    mkdir "${PYTHONLIBS}"
    pip install --target="${PYTHONLIBS}" --no-cache-dir \
        -r "${COMFYUI}/requirements.txt" \
        einops==0.8.0 \
        sageattention==1.0.6
fi

cd "${COMFYUI}/custom_nodes"
python x-flux-comfyui/setup.py
python ComfyUI-Impact-Pack/install.py
python ComfyUI-Frame-Interpolation/install.py

# Default graph handling
python3 /replaceDefaultGraph.py

# VibeVoice note: to pin transformers if needed, uncomment below line
# pip install transformers==4.49.0

# Link /ComfyUI folder to /workspace so it's available in that familiar location as well
ln -s "${COMFYUI}" /ComfyUI
