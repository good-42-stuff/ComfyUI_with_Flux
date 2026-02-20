#!/bin/bash
set -eux

# Ensure we have /workspace in all scenarios
mkdir -p /workspace

if [[ ! -d /workspace/ComfyUI ]]; then
	# If we don't already have /workspace/ComfyUI, install it there
	echo "Installing ComfyUI to /workspace, this might take a while"

    mkdir -p /workspace/ComfyUI/pysssss-workflows
    mkdir -p /workspace/ComfyUI/input
    mkdir -p /workspace/ComfyUI/models/LLM
    mkdir -p /workspace/ComfyUI/models/vibevoice/vvembed
    mkdir -p /workspace/ComfyUI/user/default/workflows
    mkdir -p /workspace/ComfyUI/models/ultralytics/bbox
    mkdir -p /ComfyUI/models/insightface
    mkdir -p /ComfyUI/models/checkpoints

	git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

	cd /workspace/ComfyUI/custom_nodes
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git
    git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git
	git clone https://github.com/XLabs-AI/x-flux-comfyui.git
	git clone https://github.com/flowtyone/ComfyUI-Flowty-LDSR.git
	git clone https://github.com/kijai/ComfyUI-SUPIR.git
	git clone https://github.com/kijai/ComfyUI-KJNodes.git
	git clone https://github.com/rgthree/rgthree-comfy.git
	git clone https://github.com/JPS-GER/ComfyUI_JPS-Nodes.git
    git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes.git
    git clone https://github.com/Jordach/comfy-plasma.git
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
	git clone https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait.git
	git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
	git clone https://github.com/ltdrdata/ComfyUI-Impact-Subpack
	git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git
	git clone https://github.com/ssitu/ComfyUI_UltimateSDUpscale --recursive
    git clone https://github.com/yolain/ComfyUI-Easy-Use.git
	git clone https://github.com/kijai/ComfyUI-Florence2.git
    git clone https://github.com/WASasquatch/was-node-suite-comfyui.git
	git clone https://github.com/theUpsider/ComfyUI-Logic.git
    git clone https://github.com/cubiq/ComfyUI_essentials.git
	git clone https://github.com/chrisgoringe/cg-image-picker.git
    git clone https://github.com/chflame163/ComfyUI_LayerStyle.git
	git clone https://github.com/shadowcz007/comfyui-mixlab-nodes.git
	git clone https://codeberg.org/Gourieff/comfyui-reactor-node.git
	git clone https://github.com/chrisgoringe/cg-use-everywhere.git
    git clone https://github.com/kijai/ComfyUI-CogVideoXWrapper.git
	git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git
	git clone https://github.com/kijai/ComfyUI-MelBandRoFormer.git
	git clone https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
	git clone https://github.com/Enemyx-net/VibeVoice-ComfyUI.git
    git clone https://github.com/kijai/ComfyUI-segment-anything-2.git
    git clone https://github.com/GACLove/ComfyUI-VFI.git
	git clone https://github.com/Lightricks/ComfyUI-LTXVideo.git
	git clone https://github.com/Fictiverse/ComfyUI_Fictiverse.git

    wget "https://github.com/comfyanonymous/ComfyUI_examples/blob/master/flux/flux_dev_example.png" -P /workspace/ComfyUI
    wget "https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt?download=true" -O /workspace/ComfyUI/models/ultralytics/bbox/face_yolov8m.pt
    wget "https://huggingface.co/ezioruan/inswapper_128.onnx/resolve/main/inswapper_128.onnx?download=true" -O /workspace/ComfyUI/models/insightface/inswapper_128.onnx
    wget "https://huggingface.co/Comfy-Org/stable-diffusion-v1-5-archive/resolve/main/v1-5-pruned-emaonly-fp16.safetensors?download=true" -O /workspace/ComfyUI/models/checkpoints/v1-5-pruned-emaonly-fp16.safetensors

    echo "Syncing custom workflows and input assets..."

    cp -r /workflows/* /workspace/ComfyUI/user/default/workflows/
    chmod -R 644 /workspace/ComfyUI/user/default/workflows/
    
    cp /comfy.settings.json /workspace/ComfyUI/user/default/comfy.settings.json
    chmod 644 /workspace/ComfyUI/user/default/comfy.settings.json

    cp *.png /workspace/ComfyUI/input/
    cp *.mp4 /workspace/ComfyUI/input/
    cp *.mp3 /workspace/ComfyUI/input/
    chmod -R 644 /workspace/ComfyUI/input/

    cp defaultGraph.json /defaultGraph.json
    chmod 644 /defaultGraph.json

    cp replaceDefaultGraph.py /replaceDefaultGraph.py
    chmod 755 /replaceDefaultGraph.py

    cp defaultGraph.json /workspace/ComfyUI/web/templates/default.json
    chmod 644 /workspace/ComfyUI/web/templates/default.json
fi

pip install --no-cache-dir -r /workspace/ComfyUI/requirements.txt

cd /workspace/ComfyUI/custom_nodes
python x-flux-comfyui/setup.py
pip install --no-cache-dir -r ComfyUI-Flowty-LDSR/requirements.txt
pip install --no-cache-dir -r ComfyUI-SUPIR/requirements.txt
pip install --no-cache-dir -r ComfyUI-KJNodes/requirements.txt
pip install --no-cache-dir -r rgthree-comfy/requirements.txt
pip install --no-cache-dir -r ComfyUI-VideoHelperSuite/requirements.txt
pip install --no-cache-dir -r ComfyUI-AdvancedLivePortrait/requirements.txt
pip install --no-cache-dir -r ComfyUI-Impact-Pack/requirements.txt
python ComfyUI-Impact-Pack/install.py
pip install --no-cache-dir -r ComfyUI-Impact-Subpack/requirements.txt
pip install --no-cache-dir -r comfyui_controlnet_aux/requirements.txt
pip install --no-cache-dir -r ComfyUI-Easy-Use/requirements.txt
pip install --no-cache-dir -r ComfyUI-Florence2/requirements.txt

pip install --no-cache-dir -r was-node-suite-comfyui/requirements.txt
pip install --no-cache-dir -r ComfyUI_essentials/requirements.txt
pip install --no-cache-dir -r ComfyUI_LayerStyle/requirements.txt
pip install --no-cache-dir -r comfyui-mixlab-nodes/requirements.txt
pip install --no-cache-dir -r comfyui-reactor-node/requirements.txt
pip install --no-cache-dir -r ComfyUI-CogVideoXWrapper/requirements.txt
pip install --no-cache-dir -r ComfyUI-WanVideoWrapper/requirements.txt
pip install --no-cache-dir sageattention==1.0.6
pip install --no-cache-dir -r ComfyUI-MelBandRoFormer/requirements.txt
python ComfyUI-Frame-Interpolation/install.py
pip install --no-cache-dir -r VibeVoice-ComfyUI/requirements.txt

pip install --no-cache-dir -r ComfyUI-VFI/requirements.txt
pip install --no-cache-dir -r ComfyUI-LTXVideo/requirements.txt
pip install --no-cache-dir -r ComfyUI_Fictiverse/requirements.txt

# Default graph handling
python3 /replaceDefaultGraph.py

# VibeVoice note: to pin transformers if needed, uncomment below line
# pip install transformers==4.49.0


# Link /ComfyUI folder to /workspace so it's available in that familiar location as well
ln -s /workspace/ComfyUI /ComfyUI
