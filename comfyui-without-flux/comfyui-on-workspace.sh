#!/bin/bash
set -eux

# Ensure we have /workspace in all scenarios
mkdir -p /workspace

if [[ ! -d /workspace/ComfyUI ]]; then
	# If we don't already have /workspace/ComfyUI, install it there
	echo "Installing ComfyUI to /workspace, this might take a while"

	git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI
    pip install --no-cache-dir -r /workspace/ComfyUI/requirements.txt
    mkdir -p /workspace/ComfyUI/pysssss-workflows

	cd /workspace/ComfyUI/custom_nodes
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git
    git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git
    
	git clone https://github.com/XLabs-AI/x-flux-comfyui.git
    python x-flux-comfyui/setup.py
    
	git clone https://github.com/flowtyone/ComfyUI-Flowty-LDSR.git
    pip install --no-cache-dir -r ComfyUI-Flowty-LDSR/requirements.txt
    
	git clone https://github.com/kijai/ComfyUI-SUPIR.git
    pip install --no-cache-dir -r ComfyUI-SUPIR/requirements.txt
    
	git clone https://github.com/kijai/ComfyUI-KJNodes.git
    pip install --no-cache-dir -r ComfyUI-KJNodes/requirements.txt
    
	git clone https://github.com/rgthree/rgthree-comfy.git
    pip install --no-cache-dir -r rgthree-comfy/requirements.txt
    
	git clone https://github.com/JPS-GER/ComfyUI_JPS-Nodes.git
    git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes.git
    git clone https://github.com/Jordach/comfy-plasma.git
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
    pip install --no-cache-dir -r ComfyUI-VideoHelperSuite/requirements.txt
    
	git clone https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait.git
    pip install --no-cache-dir -r ComfyUI-AdvancedLivePortrait/requirements.txt
    
	git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
    pip install --no-cache-dir -r ComfyUI-Impact-Pack/requirements.txt
    python ComfyUI-Impact-Pack/install.py
    
	git clone https://github.com/ltdrdata/ComfyUI-Impact-Subpack
    pip install --no-cache-dir -r ComfyUI-Impact-Subpack/requirements.txt
    
	git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git
    pip install --no-cache-dir -r comfyui_controlnet_aux/requirements.txt
    
	git clone https://github.com/ssitu/ComfyUI_UltimateSDUpscale --recursive
    git clone https://github.com/yolain/ComfyUI-Easy-Use.git
    pip install --no-cache-dir -r ComfyUI-Easy-Use/requirements.txt
    
	git clone https://github.com/kijai/ComfyUI-Florence2.git
    pip install --no-cache-dir -r ComfyUI-Florence2/requirements.txt

    mkdir -p /workspace/ComfyUI/models/LLM
    git clone https://github.com/WASasquatch/was-node-suite-comfyui.git
    pip install --no-cache-dir -r was-node-suite-comfyui/requirements.txt
    
	git clone https://github.com/theUpsider/ComfyUI-Logic.git
    git clone https://github.com/cubiq/ComfyUI_essentials.git
    pip install --no-cache-dir -r ComfyUI_essentials/requirements.txt
    
	git clone https://github.com/chrisgoringe/cg-image-picker.git
    git clone https://github.com/chflame163/ComfyUI_LayerStyle.git
    pip install --no-cache-dir -r ComfyUI_LayerStyle/requirements.txt
    
	git clone https://github.com/shadowcz007/comfyui-mixlab-nodes.git
    pip install --no-cache-dir -r comfyui-mixlab-nodes/requirements.txt
    
	git clone https://codeberg.org/Gourieff/comfyui-reactor-node.git
    pip install --no-cache-dir -r comfyui-reactor-node/requirements.txt
    
	git clone https://github.com/chrisgoringe/cg-use-everywhere.git
    git clone https://github.com/kijai/ComfyUI-CogVideoXWrapper.git
    pip install --no-cache-dir -r ComfyUI-CogVideoXWrapper/requirements.txt
    
	git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git
    pip install --no-cache-dir -r ComfyUI-WanVideoWrapper/requirements.txt
    pip install --no-cache-dir sageattention==1.0.6
    
	git clone https://github.com/kijai/ComfyUI-MelBandRoFormer.git
    pip install --no-cache-dir -r ComfyUI-MelBandRoFormer/requirements.txt
    
	git clone https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
    python ComfyUI-Frame-Interpolation/install.py
    
	git clone https://github.com/Enemyx-net/VibeVoice-ComfyUI.git
    pip install --no-cache-dir -r VibeVoice-ComfyUI/requirements.txt && \

    mkdir -p /workspace/ComfyUI/models/vibevoice/vvembed
    git clone https://github.com/kijai/ComfyUI-segment-anything-2.git
    git clone https://github.com/GACLove/ComfyUI-VFI.git
    pip install --no-cache-dir -r ComfyUI-VFI/requirements.txt
    
	git clone https://github.com/Lightricks/ComfyUI-LTXVideo.git
    pip install --no-cache-dir -r ComfyUI-LTXVideo/requirements.txt
    
	git clone https://github.com/Fictiverse/ComfyUI_Fictiverse.git
    pip install --no-cache-dir -r ComfyUI_Fictiverse/requirements.txt

    wget "https://github.com/comfyanonymous/ComfyUI_examples/blob/master/flux/flux_dev_example.png" -P /workspace/ComfyUI


# 	# App configuration and assets
# COPY --chmod=644 workflows/ /ComfyUI/user/default/workflows/
# COPY --chmod=644 comfy.settings.json /ComfyUI/user/default/comfy.settings.json
# COPY --chmod=644 character_sheet_example.png /ComfyUI/input/character_sheet_example.png
# COPY --chmod=644 example_photo.png /ComfyUI/input/example_photo.png
# COPY --chmod=644 example_photo_small.png /ComfyUI/input/example_photo_small.png
# COPY --chmod=644 example_pose.png /ComfyUI/input/example_pose.png
# COPY --chmod=644 example2.png /ComfyUI/input/example2.png
# COPY --chmod=644 driving_video.mp4 /ComfyUI/input/driving_video.mp4
# COPY --chmod=644 GracePenelopeTargaryen.mp3 /ComfyUI/input/GracePenelopeTargaryen.mp3
# COPY --chmod=644 Male-MiddleAged_American.mp3 /ComfyUI/input/Male-MiddleAged_American.mp3

    mkdir -p /workspace/ComfyUI/user/default/workflows
    mkdir -p /workspace/ComfyUI/input

    # Copy and set permissions (matches --chmod=644)
    echo "Syncing custom workflows and input assets..."

    cp -r $ASSETS_DIR/workflows/* /workspace/ComfyUI/user/default/workflows/
    cp $ASSETS_DIR/comfy.settings.json /workspace/ComfyUI/user/default/comfy.settings.json

    # Copy all images and audio to the input folder
    cp $ASSETS_DIR/*.png /workspace/ComfyUI/input/
    cp $ASSETS_DIR/*.mp4 /workspace/ComfyUI/input/
    cp $ASSETS_DIR/*.mp3 /workspace/ComfyUI/input/

    chmod -R 644 /workspace/ComfyUI/user/default/workflows/
    chmod 644 /workspace/ComfyUI/user/default/comfy.settings.json
    chmod -R 644 /workspace/ComfyUI/input/



	# mv /ComfyUI /workspace
else
	# otherwise delete the default ComfyUI folder which is always re-created on pod start from the Docker
	# rm -rf /ComfyUI
fi

# Then link /ComfyUI folder to /workspace so it's available in that familiar location as well
ln -s /workspace/ComfyUI /ComfyUI
