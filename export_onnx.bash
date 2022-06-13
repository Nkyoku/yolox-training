set -e

SCRIPT_DIR="$(cd $(dirname ${BASH_SOURCE[0]}); pwd)"

# Container version of this repository
source "$SCRIPT_DIR/version.bash"

docker run -it --rm --gpus all --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 \
    --mount type=bind,readonly,source="$SCRIPT_DIR/YOLOX",target="/root/YOLOX" \
    --mount type=bind,source="$SCRIPT_DIR/YOLOX_outputs",target="/root/YOLOX_outputs" \
    $CONTAINER_TAG \
    python3 YOLOX/tools/export_onnx.py -f YOLOX/exps/default/yolox_nano.py --output-name YOLOX_outputs/yolox_nano.onnx
