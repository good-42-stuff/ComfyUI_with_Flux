ARG DOCKER_FROM=nvidia/cuda:12.8.0-runtime-ubuntu22.04

###############################
# Builder stage
###############################
FROM nvidia/cuda:12.8.0-devel-ubuntu22.04 AS builder

# Install Python, git, and build dependencies for compiling wheels
RUN apt-get update -y && \
    apt-get install -y python3 python3-pip python3-venv python-is-python3 \
        git git-lfs \
        wget curl \
        zip unzip \
        build-essential pkg-config \
        libcairo2-dev libsqlite3-dev && \
    python3 -m pip install --upgrade pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js 22 LTS for AI-Toolkit build-time needs
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get update -y && apt-get install -y nodejs && \
    npm -v && node -v && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a virtual environment for all Python deps
ENV VENV_PATH=/opt/venv
RUN python3 -m venv ${VENV_PATH}
ENV PATH="${VENV_PATH}/bin:${PATH}"

# Install PyTorch with CUDA 12.8 in the venv
RUN pip install --no-cache-dir -U torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0 \
    --index-url https://download.pytorch.org/whl/cu128

# JupyterLab (preserve original behavior)
RUN pip install --no-cache-dir jupyterlab

# Upgrade albumentations to latest to avoid update warnings at runtime
RUN pip install --no-cache-dir -U albumentations

###############################
# Runtime stage
###############################
FROM ${DOCKER_FROM} AS runtime

# Install Python and only runtime OS packages
RUN apt-get update -y && \
    apt-get install -y python3 python3-pip python3-venv python-is-python3 \
        openssh-server openssh-client \
        git git-lfs \
        wget curl vim \ 
        zip unzip \
        nginx \
        libgl1-mesa-glx libglib2.0-0 libsqlite3-0 && \
    python3 -m pip install --upgrade pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js 22 LTS for AI-Toolkit runtime needs
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get update -y && apt-get install -y nodejs && \
    npm -v && node -v && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install uv (fast Python package manager) for ComfyUI-Manager compatibility
RUN curl -fsSL https://astral.sh/uv/install.sh | sh && \
    if [ -f "/root/.local/bin/uv" ]; then ln -sf /root/.local/bin/uv /usr/local/bin/uv; fi && \
    if [ -f "/root/.cargo/bin/uv" ]; then ln -sf /root/.cargo/bin/uv /usr/local/bin/uv; fi && \
    uv --version || true

# Nginx config
COPY default /etc/nginx/sites-available/default

# CUDA path and ensure venv binaries are preferred
ENV PATH="/opt/venv/bin:/usr/local/cuda/bin:${PATH}"

# Copy Python environment from builder
COPY --from=builder /opt/venv /opt/venv

# Startup and helper scripts
COPY --chmod=755 start-ssh-only.sh /start.sh
COPY --chmod=755 start-original.sh /start-original.sh
COPY --chmod=755 comfyui-on-workspace.sh /comfyui-on-workspace.sh
COPY --chmod=755 ai-toolkit-on-workspace.sh /ai-toolkit-on-workspace.sh
COPY --chmod=755 check_files.sh /check_files.sh

WORKDIR /workspace

# Service ports
EXPOSE 8188
EXPOSE 8888
EXPOSE 7860
EXPOSE 8675

# Download scripts for additional models
COPY --chmod=755 download_Controlnet.sh /download_Controlnet.sh
COPY --chmod=755 download_fp16.sh /download_fp16.sh
COPY --chmod=755 download_LDSR.sh /download_LDSR.sh
COPY --chmod=755 download_SUPIR.sh /download_SUPIR.sh
COPY --chmod=755 download_Florence-2.sh /download_Florence-2.sh
COPY --chmod=755 download_Upscalers.sh /download_Upscalers.sh
COPY --chmod=755 download_Outpainting.sh /download_Outpainting.sh
COPY --chmod=755 download_Workflows.sh /download_Workflows.sh
COPY --chmod=755 update_Workflows.sh /update_Workflows.sh
COPY --chmod=755 download_ALL.sh /download_ALL.sh
COPY --chmod=755 make_venv.sh /make_venv.sh
COPY --chmod=755 download_Files.sh /download_Files.sh
COPY --chmod=755 download_Flux2.sh /download_Flux2.sh
COPY --chmod=755 download_wan2.1.sh /download_wan2.1.sh
COPY --chmod=755 download_wan2.2.sh /download_wan2.2.sh
COPY --chmod=755 download_wan2.1_InfiniteTalk.sh /download_wan2.1_InfiniteTalk.sh
COPY --chmod=755 download_Qwen_bf16.sh /download_Qwen_bf16.sh
COPY --chmod=755 download_Qwen_fp8.sh /download_Qwen_fp8.sh
COPY --chmod=755 download_VibeVoice.sh /download_VibeVoice.sh
COPY --chmod=755 download_z-image.sh /download_z-image.sh
COPY --chmod=755 disable_mixlab.sh /disable_mixlab.sh
COPY --chmod=755 download_LTX2.sh /download_LTX2.sh

# fix missing directory for old network volumes
RUN mkdir -p /opt/venv/lib/python3.10/site-packages/comfyui_workflow_templates/templates

CMD [ "/start.sh" ]
