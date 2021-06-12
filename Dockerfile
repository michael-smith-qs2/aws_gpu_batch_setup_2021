# FROM python:3.8
# ^ no CUDA or pytorch
# FROM nvidia/cuda:11.3.0-cudnn8-runtime-centos8
# ^ no python, doesn't match AWS instance OS
# FROM nvidia/cuda:11.0-base  # also doesn't match AWS instance
# FROM pytorch/pytorch:latest
# ^ no CUDA
# FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime
# ^ too old, doesn't match AWS instance GPU
FROM nvcr.io/nvidia/pytorch:21.04-py3
# ^ awesome!!

# make a directory to COPY files
ENV source_path /opt/hello_pytorch/source
ENV local_path ./

# copy over necessary files
COPY ${local_path}/hello_pytorch.py ${source_path}/hello_pytorch.py
COPY ${local_path}/requirements.txt ${source_path}/requirements.txt

# install requirements
WORKDIR ${source_path}
RUN pip install -r ${source_path}/requirements.txt
# RUN pip install awscli --upgrade

# by default don't do any processing - ask for usage help
CMD ["python", "-m", "hello_pytorch", "-h"]

