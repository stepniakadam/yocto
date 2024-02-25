FROM ubuntu:22.04

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    gawk wget git diffstat unzip texinfo gcc build-essential \
    chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils\
    iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev xterm python3-subunit mesa-common-dev zstd liblz4-tool file

RUN DEBIAN_FRONTEND=noninteractive pip3 install pylint

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8

# By default, Ubuntu uses dash as an alias for sh. Dash does not support the source command
# needed for setting up Yocto build environments. Use bash as an alias for sh.
RUN which dash &> /dev/null && (\
    echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash) || \
    echo "Skipping dash reconfigure (not applicable)"

# Install the repo tool to handle git submodules (meta layers) comfortably.
ADD https://storage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/repo

