FROM tiangolo/uwsgi-nginx-flask:python3.7
ENV PYTHONHONUNBUFFERED 1
WORKDIR /app
COPY ./app /app
ENV ORACLE_HOME=/usr/lib/oracle/12.2/client64
ENV PATH=$PATH:$ORACLE_HOME/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib
RUN wget -O /tmp/oracle-instantclient-basic.rpm https://github.com/bumpx/oracle-instantclient/raw/master/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm
RUN wget -O /tmp/oracle-instantclient-sqlplus.rpm https://github.com/bumpx/oracle-instantclient/raw/master/oracle-instantclient12.2-sqlplus-12.2.0.1.0-1.x86_64.rpm 
RUN wget -O /tmp/oracle-instantclient-devel.rpm https://github.com/bumpx/oracle-instantclient/raw/master/oracle-instantclient12.2-sqlplus-12.2.0.1.0-1.x86_64.rpm
# Setup locale, Oracle instant client and Python
RUN apt-get update \
    && apt-get -y install alien libaio1 \
    && alien -i /tmp/oracle-instantclient-basic.rpm \
    && alien -i /tmp/oracle-instantclient-sqlplus.rpm \
    && alien -i /tmp/oracle-instantclient-devel.rpm
RUN ln -snf /usr/lib/oracle/12.2/client64 /opt/oracle
RUN mkdir -p /opt/oracle/network
RUN ln -snf /etc/oracle /opt/oracle/network/admin
RUN apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN pip install -r requirements.txt
