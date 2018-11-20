FROM ubuntu:16.04

ARG BAZEL_VERSION
ENV BAZEL_VERSION=$BAZEL_VERSION

# Set the locale to New Zealand
RUN sed -i 's/archive/nz.archive/' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y tzdata
RUN echo "Pacific/Auckland" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y install locales
RUN locale-gen en_NZ.UTF-8
RUN dpkg-reconfigure locales

ENV LANG en_NZ.UTF-8
ENV LANGUAGE en_NZ:en

RUN apt-get update

# Install python3
RUN apt install -y python-dev python-pip python3-dev python3-pip
# ENV PYTHON_BIN_PATH=/usr/bin/python3

# Install tensorflow dependencies
RUN pip install --upgrade pip
RUN pip install -U --user pip six numpy wheel mock enum34
RUN pip install -U --user keras_applications==1.0.5 --no-deps
RUN pip install -U --user keras_preprocessing==1.0.3 --no-deps

RUN pip3 install --upgrade pip
RUN pip3 install -U --user pip six numpy wheel mock enum34
RUN pip3 install -U --user keras_applications==1.0.5 --no-deps
RUN pip3 install -U --user keras_preprocessing==1.0.3 --no-deps

# Install bazel dependencies
RUN apt-get install -y pkg-config zip g++ zlib1g-dev unzip wget

# Download bazel
COPY bazel/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh /root

# Set permissions on bazel install file
RUN chmod +x /root/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh

# Install bazel
RUN /root/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh --user

# Add bazel to $PATH
ENV PATH $PATH:/root/.bazel/bin

# Set python3 to default python
RUN echo 'alias python=python3' >> ~/.bashrc && /bin/bash -c "source ~/.bashrc"
