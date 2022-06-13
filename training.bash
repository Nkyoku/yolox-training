set -e

SCRIPT_DIR="$(cd $(dirname ${BASH_SOURCE[0]}); pwd)"

# Container version of this repository
source "$SCRIPT_DIR/version.bash"

# Path to the dataset
TRAIN_ANNOTATIONS="$HOME/fiftyone/coco-2017/raw/instances_train2017.json"
TRAIN_DATASET_DIR="$HOME/fiftyone/coco-2017/train/data"
VALID_ANNOTATIONS="$HOME/fiftyone/coco-2017/raw/instances_val2017.json"
VALID_DATASET_DIR="$HOME/fiftyone/coco-2017/validation/data"

# Path to the pretrained .pth file
PRETRAINED_NETWORK="$SCRIPT_DIR/best_ckpt.pth"

docker run -it --rm --gpus all --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 \
    --mount type=bind,readonly,source="$SCRIPT_DIR/YOLOX",target="/root/YOLOX" \
    --mount type=bind,readonly,source="$TRAIN_ANNOTATIONS",target="/root/datasets/COCO/annotations/instances_train2017.json" \
    --mount type=bind,readonly,source="$VALID_ANNOTATIONS",target="/root/datasets/COCO/annotations/instances_val2017.json" \
    --mount type=bind,readonly,source="$TRAIN_DATASET_DIR",target="/root/datasets/COCO/train2017" \
    --mount type=bind,readonly,source="$VALID_DATASET_DIR",target="/root/datasets/COCO/val2017" \
    --mount type=bind,readonly,source="$PRETRAINED_NETWORK",target="/root/yolox.pth" \
    --mount type=bind,source="$SCRIPT_DIR/YOLOX_outputs",target="/root/YOLOX_outputs" \
    $CONTAINER_TAG \
    python3 -m yolox.tools.train -f YOLOX/exps/default/yolox_nano.py -d 1 -b 8 --fp16 -c "/root/yolox.pth"
