# speech_generating

Its main idea is from image style shift using GAN and contrastive learning method.

code is modified from https://github.com/taesungp/contrastive-unpaired-translation
                    https://github.com/shanguanma/GeneratingNoisySpeechData/tree/main/Code/Contrastive%20Unpaired%20Translation%20-%20Modifie

Thanks for their excellent work.


How to start ?
you  can see run.sh recipe

How to install this project?
just follows the below code:
```
conda create -n speechgenerate python=3.8
conda activate speechgenerate
 pip3 install -r requirements.txt -i  https://pypi.tuna.tsinghua.edu.cn/simple
``` 
or using docker
you can run the command
```
./build.sh 

```
