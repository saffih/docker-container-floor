FROM saffi/docker-container-build
MAINTAINER Saffi <saffi.h@gmail.com>

# build base python . opensssh.
# apped with apt-get clean for reducing image size in build

# done in docker-container-build image
# install sshd without startup or password settings.
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server pwgen \
#    && apt-get clean

# add python 2.7
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
   software-properties-common \
   && apt-get install -y python2.7 python2.7-dev \
   python-setuptools python-pip python-software-properties alien  \
   && apt-get clean

# add running the ssh daemon
ADD code/etc /etc

# change pass to "changeme"
# todo: change again - for dev phase only.
RUN echo 'root:changeme' > /root/passwdfile \
  && cat /root/passwdfile | chpasswd

# already done in build image
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
    

#VOLUME ["/var/log"]

# SSH Ready - if service is on.
EXPOSE 22
#######################################
# inherits that from  docker-container-build
#CMD ["-c", "/etc/supervisor/start.sh"]
#ENTRYPOINT ["bash", "--verbose", "-i","-s"]
