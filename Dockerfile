FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04
LABEL maintainer="siyan <xsy233@gmail.com>"
COPY sources.list sources.list
RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    GIT_CLONE="git clone --depth 10" && \
    # use aliyun mirror
    mv /etc/apt/sources.list /etc/apt/sources.list.bak && cp sources.list /etc/apt/ && \
    rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        build-essential \
        apt-utils \
        ca-certificates \
        wget \
        git \
        vim \
        libssl-dev \
        curl \
        unzip \
        unrar \
        software-properties-common \
        && \
# ==================================================================
# miniconda
# ------------------------------------------------------------------
    wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
	/bin/bash miniconda.sh -b -p /opt/conda && \
	rm miniconda.sh

ENV PATH /opt/conda/bin:$PATH

# ==================================================================
# python packages 
# ------------------------------------------------------------------
COPY .condarc /opt/conda/
RUN conda install pytorch torchvision cudatoolkit=10.1 -c pytorch

# ==================================================================
# config & cleanup
# ------------------------------------------------------------------
RUN ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*
