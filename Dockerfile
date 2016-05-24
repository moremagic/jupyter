FROM ubuntu:15.04
MAINTAINER moremagic <itoumagic@gmail.com>

RUN apt-get update && apt-get install -y openssh-server openssh-client
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config


# python install
RUN apt-get install -y wget curl tar zip gcc make g++
RUN apt-get install -y python2.7-dev python-numpy python-opencv libfreetype6-dev libxft-dev
RUN curl -kL https://bootstrap.pypa.io/get-pip.py | /usr/bin/python2.7
RUN python2 -m pip install ipykernel
RUN python2 -m pip install pandas
RUN python2 -m pip install matplotlib
RUN python2 -m pip install networkx
RUN python2 -m pip install pyyaml
RUN python2 -m pip install xlsxwriter
RUN python2 -m pip install tornado


RUN apt-get install -y python3-dev
RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python3
RUN pip install jupyter ipython[notebook]
RUN python3 -m pip install ipykernel
RUN python3 -m pip install pandas
RUN python3 -m pip install matplotlib
RUN python3 -m pip install networkx
RUN python3 -m pip install pyyaml
RUN python3 -m pip install xlsxwriter
RUN python3 -m pip install tornado

RUN ipython2 kernel install --name python2
RUN ipython3 kernel install --name python3

RUN printf '#!/bin/bash \n\
jupyter notebook --ip=0.0.0.0 --notebook-dir=/root > /var/log/notebook.log & \n\
/usr/sbin/sshd -D \n\
tail -f /var/null \n\
' >> /etc/service.sh \
    && chmod +x /etc/service.sh

EXPOSE 22 8888
CMD ["/etc/service.sh"]
