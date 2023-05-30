"""A modified image folder class

We modify the official PyTorch image folder (https://github.com/pytorch/vision/blob/master/torchvision/datasets/folder.py)
so that this class can load images from both current directory and its subdirectories.
"""

import torch.utils.data as data

from PIL import Image
import os
import os.path
from pathlib import Path


def make_dataset(dir, max_dataset_size=float("inf")):
    files = []
    assert os.path.isdir(dir) or os.path.islink(dir), (
        "%s is not a valid directory" % dir
    )

    for root, _, fnames in sorted(os.walk(dir, followlinks=True)):
        for fname in fnames:
            path = os.path.join(root, fname)
            files.append(path)
    return files[: min(max_dataset_size, len(files))]


def make_scp_dataset(dir, max_dataset_size=float("inf")):
    files = []
    assert os.path.isdir(dir)
    path = f"{dir}/wav.scp"
    with Path(path).open("r", encoding="utf-8") as f:
        for line in f:
            line = line.strip().split()
            files.append(line[1])
    return files[: min(max_dataset_size, len(files))]


def make_scp_test_dataset(inscp, max_dataset_size=float("inf")):
    files = []
    #assert os.path.isdir(dir)
    assert inscp.endswith(".scp")
    path = inscp
    with Path(path).open("r", encoding="utf-8") as f:
        for line in f:
            line = line.strip().split()
            files.append(line[1])
    return files[: min(max_dataset_size, len(files))]
