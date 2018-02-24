FROM ubuntu:16.04

MAINTAINER Wei-Ming Wu <wnameless@gmail.com>

ENV ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib
ENV PATH=$ORACLE_HOME/bin:$PATH
ENV ORACLE_SID=XE
ENV ORACLE_ALLOW_REMOTE=true
ENV NLS_LANG="SIMPLIFIED CHINESE_CHINA.AL32UTF8"
ENV PROXY=http://192.168.1.8:2345/pac

ADD setup1.sh /setup1.sh
RUN mkdir /assets && \
    cd /assets && \
    sh /setup1.sh && \
    rm -f /setup1.sh
RUN wget 10.0.1.129/oracle-xe-10g-univ-assets.tar.gz && \
    tar zxvf oracle-xe-10g-univ-assets.tar.gz && \
    rm -rf oracle-xe-10g-univ-assets.tar.gz && \
    sh /assets/setup2.sh

EXPOSE 1521 8080

CMD /oracle-startup.sh && /usr/sbin/sshd -D
