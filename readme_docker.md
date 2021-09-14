# The Docker Base Image and Dockerfile
For an initial test, you can build FROM python:3.8 and have torch as a requirement.

However, please note that should you encounter other errors in production, see below for information on other images you might try to use.

While pytorch has a docker hub, and nvidia does too, nvidia also hosts pytorch- and cuda-ready images here (available via e.g., `docker pull nvcr.io/nvidia/pytorch:21.05-py3`). 

If your project requires something more advanced, you'll want to choose the latter, Nvidia's Pytorch image, for the following reasons/errors/issues:
- Using `FROM python:3.8` or `3.9` or similar runs on AWS instances (including the `p` and `g` families with GPUs), but may be missing CUDA-specific infrastructure for advanced pytorch calculations
- Using only the pytorch image in a Dockerfile via `FROM pytorch/pytorch:latest` won't have the necessary nvidia infrastructure, so if you need something more advanced than the base python we recommend choosing the nvidia image if pairing with `g4dn`.
- Using Nvidia's base image e.g., `FROM nvidia/cuda:11.3.0-cudnn8-runtime-centos8` doesn't match the AWS GPU instances
- Of note, the nvidia GPU instance `g4dn` we chose here requires environment variables for CUDA to work. It turns out that some of these come with the image and some don't.

TL;DR, make note of your preferred values for `NVIDIA_REQUIRE_CUDA` and `NVIDIA_DRIVER_CAPABILITES` environment variables.
