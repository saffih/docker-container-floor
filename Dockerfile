FROM saffi/docker-container-build
#FROM ubuntu:14.04

MAINTAINER Saffi <saffi.h@gmail.com>
ENV container docker

# Add resolv.conf
#nameserver 8.8.8.8
#nameserver 8.8.8.4
ADD code/etc/resolv.conf /etc/resolv.conf

# build base python and supervisor. opensssh
# apped with apt-get clean for reducing image size in build.
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    apt-get install -y build-essential git  supervisor && apt-get clean

# install sshd without startup or password settings.
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server pwgen \
    && apt-get clean

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
   python2.7 python-pip python2.7-dev  && apt-get clean


ADD code/etc /etc

# to do 
RUN echo 'root:changeme' > /root/passwdfile \
  && cat /root/passwdfile | chpasswd

RUN echo 'configure sshd' \
    && mkdir -p /var/run/sshd \
    && sed -ri 's/^UsePrivilegeSeparation /#UsePrivilegeSeparation /g' /etc/ssh/sshd_config \
    && sed -ri 's/^UsePAM /#UsePAM /g' /etc/ssh/sshd_config \
    && sed -ri 's/^PermitRootLogin /#PermitRootLogin /g' /etc/ssh/sshd_config \
    && echo 'PermitRootLogin yes'>> /etc/ssh/sshd_config \
    && echo 'UsePAM no'>> /etc/ssh/sshd_config \
    && echo 'UsePrivilegeSeparation no'>> /etc/ssh/sshd_config \
    && echo 'sshd_config:' \
    && cat /etc/ssh/sshd_config


# force bash to start it all WITHIN bash. AND trap EXIT so we loop forever on serverd  on break unload
RUN echo ". /etc/bashload/hook.sh" >> /etc/bash.bashrc && \
    echo ". /etc/bashload/onstart.sh" > /etc/bashload/hook.sh 

#VOLUME ["/var/log"]
#VOLUME ["/etc/bashload"]

# SSH Ready - if service is on.
EXPOSE 22
##############################################
ENTRYPOINT bash --verbose -s -i 
#CMD[""]
