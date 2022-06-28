# 基础镜像
FROM python:3.9-bullseye
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN sed -i -e 's/deb.debian.org/mirrors.ustc.edu.cn/g' \
    -e 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y build-essential libssl-dev libffi-dev libsasl2-dev libldap2-dev libmariadb-dev-compat libpq-dev
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install Pillow markupsafe==2.0.1 apache-superset mysqlclient psycopg2 clickhouse-driver==0.2.0 clickhouse-sqlalchemy==0.1.8
RUN mkdir -p /etc/superset 
ADD superset_config.py /etc/superset
ENV PYTHONPATH=/etc/superset
ENV FLASK_APP=superset
RUN superset db upgrade
RUN superset fab create-admin --username admin --firstname admin --lastname gmt --email admin@gmt.com --password 123 && \
    superset load_examples && \
    superset init
      
ENTRYPOINT [ "superset", "run", "-h", "0.0.0.0", "-p", "8088", "--with-threads", "--reload", "--debugger" ]
