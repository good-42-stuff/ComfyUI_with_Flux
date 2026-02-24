ARG BUILDER_BASE=nvidia/cuda:12.8.0-devel-ubuntu22.04
ARG RUNTIME_BASE=nvidia/cuda:12.8.0-runtime-ubuntu22.04

# Builder stage =====================
FROM ${BUILDER_BASE} AS builder

# Install Python, git, and build dependencies for compiling wheels
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        python3 python3-pip python3-venv python-is-python3 \
        git git-lfs \
        wget curl \
        zip unzip \
        build-essential pkg-config \
        libcairo2-dev libsqlite3-dev && \
    python3 -m pip install --no-cache-dir --upgrade pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js 22 LTS for AI-Toolkit build-time needs
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get update -y && apt-get install -y --no-install-recommends nodejs && \
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

# Clean python cache
RUN find /opt/venv -type d -name "__pycache__" -exec rm -rf {} +

# Runtime stage =====================
FROM ${RUNTIME_BASE} AS runtime

# Install Python and only runtime OS packages
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv python-is-python3 \
        openssh-server openssh-client \
        git git-lfs \
        wget curl vim \ 
        zip unzip \
        nginx \
        libgl1-mesa-glx libglib2.0-0 libsqlite3-0 && \
    python3 -m pip install --no-cache-dir --upgrade pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js 22 LTS for AI-Toolkit runtime needs
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends nodejs && \
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
COPY --chmod=755 scripts/ /

# Fix missing directory for old network volumes
RUN mkdir -p /opt/venv/lib/python3.10/site-packages/comfyui_workflow_templates/templates

WORKDIR /workspace

# Service ports
EXPOSE 8188
EXPOSE 8888
EXPOSE 7860
EXPOSE 8675

CMD [ "/start.sh" ]
