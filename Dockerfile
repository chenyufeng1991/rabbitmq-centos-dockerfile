FROM centos:6.7
MAINTAINER chenyufeng "yufengcode@gmail.com"

WORKDIR /usr/local

RUN yum install -y gcc glibc-devel make ncurses-devel openssl-devel xmlto perl wget && \
    rpm --rebuilddb && \
    yum install -y tar && \
    yum install -y xz && \
    wget http://www.erlang.org/download/otp_src_18.3.tar.gz && \
    tar -xzvf otp_src_18.3.tar.gz && \
    rm -f otp_src_18.3.tar.gz

WORKDIR /usr/local/otp_src_18.3

RUN ./configure --prefix=/usr/local/erlang && \
    make && make install

ENV ERL_HOME /usr/local/erlang
ENV PATH $PATH:$ERL_HOME/bin

WORKDIR /home

RUN wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.1/rabbitmq-server-generic-unix-3.6.1.tar.xz && \
    xz -d rabbitmq-server-generic-unix-3.6.1.tar.xz && \
    tar -xvf rabbitmq-server-generic-unix-3.6.1.tar && \  
    mv rabbitmq_server-3.6.1/ rabbitmq && \
    rm -f rabbitmq-server-generic-unix-3.6.1.tar && \
    yum clean all

ENV RABBITMQ_HOME /home/rabbitmq
ENV PATH $PATH:$RABBITMQ_HOME/sbin

EXPOSE 5672
EXPOSE 15672

ENTRYPOINT rabbitmq-plugins enable rabbitmq_management && rabbitmq-server

CMD ["rabbitmq-server"]
