FROM python:3.9-alpine3.13
LABEL maintainer="pmahajan1127@gmail.com"

ENV PYTHONUNBUFFERED=1

# RUN apk add --no-cache python3 py3-virtualenv

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true"]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

RUN pip install --no-cache-dir flake8


ENV PATH="/py/bin:$PATH"

USER django-user

