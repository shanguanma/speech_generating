 docker run -itd --network host --ipc=host --gpus all -v /mnt/4T_c/md:/mnt/4T_c/md -v /mnt/4T_b/md:/mnt/4T_b/md -v /home/maduo:/home/maduo cuda11.1_devel_ubuntu20.04_conda:latest


conda create -n speechgenerate python=3.8
conda activate speechgenerate
 pip3 install -r requirements.txt -i  https://pypi.tuna.tsinghua.edu.cn/simple
apt update && apt install vim wget git tmux -y
