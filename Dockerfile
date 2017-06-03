FROM ubuntu:16.04

MAINTAINER Wei-Ming Wu <wnameless@gmail.com>

ENV ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib
ENV PATH=$ORACLE_HOME/bin:$PATH
ENV ORACLE_SID=XE
ENV ORACLE_ALLOW_REMOTE=true
ENV NLS_LANG="SIMPLIFIED CHINESE_CHINA.AL32UTF8"

ADD assets/setup1.sh /assets/setup1.sh
RUN /assets/setup1.sh
ADD assets /assets
RUN /assets/setup2.sh

EXPOSE 22 1521 8080

CMD /oracle-startup.sh && /usr/sbin/sshd -D
