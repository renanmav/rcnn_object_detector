FROM tensorflow/tensorflow:2.4.2-gpu

# Remove logging info about GPU processing
ENV TF_CPP_MIN_LOG_LEVEL=3

# Set working directory
# Use the following docker flag
#   -v $PWD:/home/rcnn_object_detector
ARG ROOT_DIR=/home/rcnn_object_detector
RUN mkdir -p ${ROOT_DIR}
WORKDIR ${ROOT_DIR}

CMD ["bash"]