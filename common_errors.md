---

Common Errors and Explanations
This section has details of the errors from permutations we tried, and apparent resolutions, should you encounter them.
Docker errors
Error: /bin/sh: pip: command not found
There's no pip executable in your FROM image. This can happen, for example, when you use an nvidia cuda image that doesn't have python installed.
Fix: It was much easier to go from a pytorch image than to try to install python yourself inside an nvidia image. But feel free to try to install python if you're feeling adventurous.

---

Error: Your docker build couldn't get information on the nvidia image, such that you get something like the following:
> [internal] load metadata for nvcr.io/nvidia/pytorch:21.04-py3:
 ------
 failed to solve with frontend dockerfile.v0: failed to create LLB definition: failed to authorize: rpc error: code = Unknown desc = failed to fetch anonymous token: unexpected status: 401 Unauthorized
Fix: Not to worry - in our experience this is a temporary problem, often with an immediate fix:
Sometimes it involves some sort of token in your local docker executable - you can either docker system prune or if needed on WSL2 follow these steps and try again and it will work.
Other times this procedure doesn't enable the authorization to happen - it seems like nvidia occasionally brings their site down for maintenance in the evenings (eastern time)? –waiting a few hours does the trick.

AWS Errors
Error: NVIDIA RuntimeError on CloudWatch (we saw two potential causes):
RuntimeError: Found no NVIDIA driver on your system. Please check that you have an NVIDIA GPU and installed a driver from http://www.nvidia.com/Download/index.aspx
Reason 1: you allowed an instance type that didn't have a GPU installed, so your compute environment provided such an instance to run your containerized pytorch code.
Fix 1: Double-check your allowed instances - note that the verbatim choice optimal is not actually optimal for this GPU use case! While p4 will sometimes work, try choosing one in the g family.
Reason 2: you forgot the NVIDIA environment variables!
Fix: See above.

---

Error: Job stuck in RUNNABLE status?
Fix: You may not have provisioned enough resources (i.e., beef up your instance type!) https://aws.amazon.com/premiumsupport/knowledge-center/batch-job-stuck-runnable-status/

---

Error: "Cannot start container error", something like
CannotStartContainerError: Error response from daemon: OCI runtime create failed: container_linux.go:370: starting container process caused: process_linux.go:459: container init caused: Running hook #0:: error running hook: exit status 1, stdout: , stderr
These are nested errors inside of docker launching. You want to pay attention to the right-most (i.e., most-nested) response. In this case, there isn't really anything useful or helpful in the message itself. This means the container launch didn't get far enough to be able to log anything meaningful.
Fix: trial and error, unfortunately. Something core to the compatibility of the image and instance is mismatched.
For example, I got this error when I built FROM python:3.8 in my Dockerfile. The image had no GPU support so it couldn't launch in a GPU instance.
I also got this error with FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime on a g4dn instance. CUDA didn't work with that instance's GPU, I'm guessing?
The same thing happened with FROM pytorch:pytorch/latest on a p2instance.

---

Error: "Task failed to start", because of
CannotPullContainerError: failed to register layer: Error processing tar file(exit status 1): write /opt/conda/lib/python3.7/site-packages/torch/lib/libtorch_cuda.so: no space left on device
Fix: You ran out of space on your instance type. Pick a beefier one!

---

Error: "Essential container in task exited", because of OutOfMemoryError: Container killed due to memory usage
Fix: Make your job definition or submission have a higher RAM limit

---

Error: CUDA memory error: CUDA out of memory try reducing batch size or increasing GPU memory
Fix: Choose an instance with a beefier GPU!
