# 基础镜像
FROM python:3.9-bullseye
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free > /etc/apt/sources.list ;\
    echo deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free >> /etc/apt/sources.list  ;\
    echo deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free >> /etc/apt/sources.list ;\
    echo deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free >> /etc/apt/sources.list  
RUN apt-get update && apt-get install -y build-essential libssl-dev libffi-dev libsasl2-dev libldap2-dev libmariadb-dev-compat libpq-dev
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install Pillow apache-superset mysqlclient psycopg2
RUN mkdir -p /etc/superset 
ADD superset_config.py /etc/superset
ENV PYTHONPATH=/etc/superset
RUN superset db upgrade
RUN export FLASK_APP=superset && \
      superset fab create-admin --username admin --firstname admin --lastname gmt --email admin@gmt.com --password 123 && \
      superset load_examples && \
      superset init
      
ENTRYPOINT [ "superset", "run", "-h", "0.0.0.0", "-p", "8088", "--with-threads", "--reload", "--debugger" ]
