FROM ubuntu:15.04
MAINTAINER moremagic <itoumagic@gmail.com>

RUN apt-get update && apt-get install -y openssh-server openssh-client
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config


# python install
RUN apt-get install -y wget curl tar zip gcc make g++ python3-dev 
RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python3
RUN pip install jupyter ipython[notebook]


RUN printf '#!/bin/bash \n\
jupyter notebook --ip=0.0.0.0 > /var/log/notebook.log & \n\
/usr/sbin/sshd -D \n\
tail -f /var/null \n\
' >> /etc/service.sh \
    && chmod +x /etc/service.sh

EXPOSE 22 8888
CMD ["/etc/service.sh"]
