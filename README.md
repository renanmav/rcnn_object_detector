# rcnn_object_detector

Based on [this blog post](https://www.pyimagesearch.com/2020/07/13/r-cnn-object-detection-with-keras-tensorflow-and-deep-learning/) by Adrian Rosebrock.

GPU enabled.

# Run it

With docker GPU support enabled, run:

```
# Build image based on Dockerfile and tag it
docker build -t rcnnobjectdetector .

# Run interactive container with repository volume mapping and gpu support
docker run -it --rm \
    --gpus all \
    -u $(id -u):$(id -g) \
    -v $PWD:/home/rcnn_object_detector rcnnobjectdetector
```
