# 基于centos6基础镜像
FROM centos:6
MAINTAINER chenyufeng "yufengcode@gmail.com"

WORKDIR /usr/local

# 安装一些前置环境
RUN yum install -y gcc glibc-devel make ncurses-devel openssl-devel xmlto perl wget xz lsof && \
    rpm --rebuilddb && \
    yum install -y tar && \
    wget http://www.erlang.org/download/otp_src_18.3.tar.gz && \
    tar -xzvf otp_src_18.3.tar.gz && \
    rm -f otp_src_18.3.tar.gz && \
    yum clean all

WORKDIR /usr/local/otp_src_18.3

RUN ./configure --prefix=/usr/local/erlang && \
    make && make install

ENV ERL_HOME /usr/local/erlang
ENV PATH $PATH:$ERL_HOME/bin

WORKDIR /home

# 安装rabbitmq
RUN wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.1/rabbitmq-server-generic-unix-3.6.1.tar.xz && \
    xz -d rabbitmq-server-generic-unix-3.6.1.tar.xz && \
    tar -xvf rabbitmq-server-generic-unix-3.6.1.tar && \  
    mv rabbitmq_server-3.6.1/ rabbitmq && \
    rm -f rabbitmq-server-generic-unix-3.6.1.tar && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    yum clean all

# 配置环境变量
ENV RABBITMQ_HOME /home/rabbitmq
ENV PATH $PATH:$RABBITMQ_HOME/sbin
ENV TZ Asia/Shanghai

# 开放端口
EXPOSE 5672 15672

# 启动容器后执行命令
ENTRYPOINT rabbitmq-plugins enable rabbitmq_management && rabbitmq-server

CMD ["rabbitmq-server"]
