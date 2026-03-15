#!/bin/bash

# You can make modifications to this file if you want to customize the startup process.
# Things like installing additional custom nodes, or downloading models can be done here.

ln -s /opt/ComfyUI /workspace/ComfyUI

# Update the included workflows
bash /scripts/update_Workflows.sh

# Disable Mixlab nodes because they take a long time load and are no longer needed in any of the included workflows.
# But can be enabled if needed by commenting out the following line.
bash /scripts/disable_mixlab.sh

# Launch the UI
python3 /workspace/ComfyUI/main.py --listen

# Keep the container running indefinitely
sleep infinity
