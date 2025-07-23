Demo of creating and running a container with Apptainer on Andes, that has GPU access and graphics
with Vulkan, and is viewable with a VNC viewer.


## To build contianer:

```
apptainer build myvulkan.sif myvulkan.def
```

## To run the sinewave simpleVulkan demo

```
$ ssh -Y <username>@andes.olcf.ornl.gov
$ apptainer shell --nv --env DISPLAY=$DISPLAY ./myvulkan.sif
Apptainer>  cd /opt/cuda-samples/Samples/5_Domain_Specific/simpleVulkan/build/
Apptainer> ./simpleVulkan
```

It technically runs. The framerate is terrible.


## Running with VNC (and with a much better framerate):

**Prerequisite:** 
Install the turboVNC viewer on your personal computer 
https://www.turbovnc.org/

You will need two terminals opened on your personal computer:

**Terminal 1:**
```
ssh <username>@andes.olcf.ornl.gov

# Start an interactive job on Andes GPU
# Make a note of which GPU node you were allocated
salloc -A stf007  -t 00:30:00 -N1 -p gpu

# Optional: set the proxy environment variables in case you need internet connection
export all_proxy=socks://proxy.ccs.ornl.gov:3128/
export ftp_proxy=ftp://proxy.ccs.ornl.gov:3128/
export http_proxy=http://proxy.ccs.ornl.gov:3128/
export https_proxy=http://proxy.ccs.ornl.gov:3128/
export no_proxy='localhost,127.0.0.0/8,*.ccs.ornl.gov'

# Start apptainer shell
apptainer shell --nv ./myvulkan.sif

# Start the entrypoint.sh script, which starts the XFCE desktop environment and the VNC server
/home/vncuser/entrypoint.sh # or you can start it from the current dir if you have it there with ./entrypoint.sh
```

**Terminal 2:**
```
# set up port forwarding connections for TurboVNC viewer to connect to the running VNC server
ssh -L 5901:localhost:5901 subil@andes.olcf.ornl.gov
ssh -4L 5901:localhost:5901 <andes-gpu nodename> # use andes-gpu nodename you noted from earlier. Or check with `squeue --me` to check what node was alocated to you
```

Then open TurboVNC viewer and enter `localhost:5901` in the address bar. That should open an XFCE desktop. 

Then open a terminal in the desktop environment. Then run
```
vulkaninfo | grep 'deviceName'
```
This verifies if the GPU is visible to the running container.

Then try to run a simpleVulkan example
```
/opt/cuda-samples/Samples/5_Domain_Specific/simpleVulkan/build/simpleVulkan
```




