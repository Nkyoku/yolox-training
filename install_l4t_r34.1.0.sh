cd $(dirname ${BASH_SOURCE[0]})

source ./version.bash

docker build -t $CONTAINER_TAG - << EOS
FROM nvcr.io/nvidia/l4t-ml:r34.1.0-py3
WORKDIR /root
RUN pip3 install --no-deps git+https://github.com/Megvii-BaseDetection/YOLOX.git \
 && pip3 install loguru thop pycocotools tabulate tqdm \
 && mkdir -p datasets/COCO/annotations
ENV YOLOX_DATADIR=/root/datasets
EOS
