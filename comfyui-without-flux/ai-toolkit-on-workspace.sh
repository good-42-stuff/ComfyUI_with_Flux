#!/bin/bash
set -eux

# Ensure we have /workspace in all scenarios
mkdir -p /workspace

if [[ ! -d /workspace/ai-toolkit ]]; then
	echo "Installing ai-toolkit to /workspace, this might take a while"

	mkdir -p /workspace/ai-toolkit

	git clone https://github.com/ostris/ai-toolkit.git /workspace/ai-toolkit

	# AI-Toolkit default config and utility
	cp ai-toolkit/train_lora.yaml /workspace/ai-toolkit/config/train_lora.yaml
	chmod 644 /workspace/ai-toolkit/config/train_lora.yaml
	
	cp ai-toolkit/caption_images.py /workspace/caption_images.py
	chmod 755 /workspace/caption_images.py
fi

cd /wokspace/ai-toolkit && git submodule update --init --recursive
pip install --no-cache-dir -r requirements.txt

cd /workspace/ai-toolkit/ui
npm ci || npm install
npm run update_db
npm run build

# Then link /ai-toolkit folder to /workspace so it's available in that familiar location as well
ln -s /workspace/ai-toolkit /ai-toolkit

# Ensure we have /workspace/training_sets in all scenarios
mkdir -p /workspace/training_set
mkdir -p /workspace/LoRas

# when trained using the UI, the result is stored in /workspace/ai-toolkit/output
ln -s /workspace/ai-toolkit/output /workspace/ComfyUI/models/loras/flux_train_ui

# when trained using the CLI, the result set is stored in /workspace/LoRas (don't put it in /workspace/ai-toolkit/output because it will create a symlink loop)
ln -s /workspace/LoRas /workspace/ComfyUI/models/loras/ai-toolkit
