cd $(dirname ${BASH_SOURCE[0]})

source ./version.bash

docker build -t $CONTAINER_TAG - << EOS
FROM nvcr.io/nvidia/pytorch:22.05-py3
WORKDIR /root
RUN apt update \
 && apt install -y --no-install-recommends libgl1
RUN pip3 install opencv-python==4.5.5.64 \
 && pip3 install git+https://github.com/Megvii-BaseDetection/YOLOX.git \
 && mkdir -p datasets/COCO/annotations
ENV YOLOX_DATADIR=/root/datasets
EOS
