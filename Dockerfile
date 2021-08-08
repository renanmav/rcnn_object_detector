FROM tensorflow/tensorflow:2.4.2

# Update pip
RUN python3 -m pip install --upgrade pip

# Install OpenCV with CUDA support
ARG OPENCV_VERSION=4.5.3
RUN apt-get update && apt-get upgrade -y &&\
    # Install build tools, build dependencies and python
    apt-get install -y \
	python3-pip \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libavformat-dev \
        libpq-dev \
        libxine2-dev \
        libglew-dev \
        libtiff5-dev \
        zlib1g-dev \
        libjpeg-dev \
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        libpostproc-dev \
        libswscale-dev \
        libeigen3-dev \
        libtbb-dev \
        libgtk2.0-dev \
        pkg-config \
        ## Python
        python3-dev \
        python3-numpy \
    && rm -rf /var/lib/apt/lists/*
RUN cd /opt/ &&\
    # Download and unzip OpenCV and opencv_contrib and delte zip files
    wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip &&\
    unzip $OPENCV_VERSION.zip &&\
    rm $OPENCV_VERSION.zip &&\
    wget https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip &&\
    unzip ${OPENCV_VERSION}.zip &&\
    rm ${OPENCV_VERSION}.zip &&\
    # Create build folder and switch to it
    mkdir /opt/opencv-${OPENCV_VERSION}/build && cd /opt/opencv-${OPENCV_VERSION}/build &&\
    # Cmake configure
    cmake \
        -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-${OPENCV_VERSION}/modules \
        -D WITH_CUDA=OFF \
        -D WITH_CUDNN=OFF \
        -D OPENCV_DNN_CUDA=OFF \
        -D CMAKE_BUILD_TYPE=RELEASE \
        # TODO: add CUDA and CUDNN here
        #
        # Examples:
        # -D ENABLE_FAST_MATH=1 \
        # -D CUDA_FAST_MATH=1 \
        # -D CUDA_cublas_LIBRARY=/usr/lib/x86_64-linux-gnu/libcublas.so \
        # -D CUDA_cufft_LIBRARY=/usr/lib/x86_64-linux-gnu/libcufft.so \
        # -D CUDA_nppc_LIBRARY=/usr/lib/x86_64-linux-gnu/libnppc.so \
        # -D CUDNN_INCLUDE_DIR=/usr/include \
        # -D CUDNN_LIBRARY=/usr/lib64/libcudnn_static_v7.a \
        # -D CUDNN_VERSION=7.6.3 \
        #
        # Install path will be /usr/local/lib (lib is implicit)
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        .. &&\
    # Make
    make -j"$(nproc)" && \
    # Install to /usr/local/lib
    make install && \
    ldconfig &&\
    # Remove OpenCV sources and build folder
    rm -rf /opt/opencv-${OPENCV_VERSION} && rm -rf /opt/opencv_contrib-${OPENCV_VERSION}

# Remove logging info about GPU processing
ENV TF_CPP_MIN_LOG_LEVEL=3

# Set working directory
# Use the following docker flag
#   -v $PWD:/home/rcnn_object_detector
ARG ROOT_DIR=/home/rcnn_object_detector
RUN mkdir -p ${ROOT_DIR}
WORKDIR ${ROOT_DIR}

# Copy and install requirements.txt packages
ADD requirements.txt .
RUN pip install -r requirements.txt

# Configure matplotlib
RUN mkdir -p /.config/matplotlib
RUN chmod 777 /.config/matplotlib
ENV MPLCONFIGDIR=/.config/matplotlib

# Copy all files
ADD . .

CMD ["bash"]