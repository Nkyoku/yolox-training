# YOLOX training environment

## Installation
1. Clone this repository.
```
git clone --recursive https://github.com/Nkyoku/yolox-training.git
```
or
```
git clone https://github.com/Nkyoku/yolox-training.git
cd yolox-training
git submodule update --init --recursive
```

2. Set default runtime of Docker to `nvidia`.  
   Add a line `"default-runtime": "nvidia",` to `/etc/docker/daemon.json`.  
   This makes `docker build` to be able to build with CUDA runtime libraries.
```
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
```

3. Execute `install_xxxx.sh`
  - Jetson with L4T R34.1.0  
    `./install_l4t_r34.1.0.sh`
  - x86_64
    `./install_x86_64.sh`

4. Download pretrained network  
  for example `wget https://github.com/Megvii-BaseDetection/YOLOX/releases/download/0.1.1rc0/yolox_nano.pth`

## Training
1. Edit dataset path and hyper parameters by editing `training.bash` and corresponding model's `YOLOX/exps/default/yolox_xxxx.py`.
2. Execute `./training.bash`

## Tips
- If below error message were shown while `docker build`, 
```
failed to create shim: OCI runtime create failed: container_linux.go:380: starting container process caused: error adding seccomp filter rule for syscall clone3: permission denied: unknown
```
  Try this [workaround](https://github.com/dusty-nv/jetson-containers/issues/108#issuecomment-995090398).
```
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
 && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
 && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install nvidia-docker2=2.8.0-1
```
