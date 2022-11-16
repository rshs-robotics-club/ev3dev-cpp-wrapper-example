FROM ev3dev/debian-stretch-cross:latest

RUN wget https://github.com/Kitware/CMake/releases/download/v3.24.0/cmake-3.24.0.tar.gz
RUN tar -zxvf cmake-3.24.0.tar.gz
RUN cd cmake-3.24.0 && \
    sudo apt-get update -y && \
    sudo apt-get install -y build-essential && \
    sudo apt-get install -y libssl-dev && \
    ./bootstrap && \
    make -j $(nproc) && \
    sudo apt-get remove --purge cmake -y && \
    sudo make install && \
    rm -r *
# install libbluetooth-dev for cross compiling
RUN wget http://security.debian.org/debian-security/pool/updates/main/b/bluez/libbluetooth-dev_5.43-2+deb9u5_armel.deb
RUN dpkg -x libbluetooth-dev_5.43-2+deb9u5_armel.deb ./temp && \
    mkdir ./crossCompileLibraries && \
    mkdir ./crossCompileLibraries/libbluetooth && \
    cp -r ./temp/usr/. ./crossCompileLibraries/libbluetooth && \
    rm -r ./temp