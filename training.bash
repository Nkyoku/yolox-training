set -e

source ./version.bash

TRAIN_ANNOTATIONS="$HOME/fiftyone/coco-2017/raw/instances_train2017.json"
TRAIN_DATASET_DIR="$HOME/fiftyone/coco-2017/train"

VALID_ANNOTATIONS="$HOME/fiftyone/coco-2017/raw/instances_val2017.json"
VALID_DATASET_DIR="$HOME/fiftyone/coco-2017/validation"

SHARED_MEMORY="1g"

SCRIPT_DIR="$(cd $(dirname ${BASH_SOURCE[0]}); pwd)"

docker run -it --rm \
    --mount type=bind,source="$SCRIPT_DIR/YOLOX",target="/root/YOLOX" \
    --mount type=bind,readonly,source="$TRAIN_ANNOTATIONS",target="/root/datasets/COCO/annotations/instances_train2017.json" \
    --mount type=bind,readonly,source="$VALID_ANNOTATIONS",target="/root/datasets/COCO/annotations/instances_val2017.json" \
    --mount type=bind,readonly,source="$TRAIN_DATASET_DIR",target="/root/datasets/COCO/train2017" \
    --mount type=bind,readonly,source="$VALID_DATASET_DIR",target="/root/datasets/COCO/val2017" \
    --shm-size="$SHARED_MEMORY" $CONTAINER_TAG python3 -m yolox.tools.train -f YOLOX/exps/default/yolox_nano.py -d 1 -b 8 --fp16
