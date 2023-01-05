ARG         base=python:3.10.9-slim-buster


###

FROM        ${base} as build

ARG         version=0.3.2

WORKDIR     /usr/src/app
COPY        requirements.txt .

RUN         apt-get update && \
            apt-get install -y \
                build-essential && \
            pip install -r requirements.txt ckip-transformers==${version} && \
            apt-get remove -y build-essential

###

FROM        python:3.10.6-slim-buster
###

ARG         model=bert-base

WORKDIR     /usr/src/app

ENV         PYTHONUNBUFFERED=1
ENV         CKIP_TRANSFORMER_MODEL=${model}

COPY        --from=build /usr/local /usr/local
COPY        app.py app.py
COPY        config/uwsgi.ini config/uwsgi.ini

# RUN         flask shell
