FROM gliderlabs/alpine:3.2

WORKDIR /app
COPY . /app

# Add ftp2http config
COPY files/etc/ftp2http.conf.j2 /etc/

# Required packages for ftp2http
RUN apk --update add \
    libffi-dev \
    openssl-dev \
    python \
    py-setuptools

# Update apk package list and python requirements, install ftp2http, then cleanup
RUN apk --update add --virtual build-dependencies build-base py-pip python-dev \
    && pip install --upgrade -r requirements.txt \
    && pip install ftp2http \
    && apk del build-dependencies

# On boot, update the config with correct environment settings
RUN chmod +x setup.sh
ENTRYPOINT /app/setup.sh && ftp2http
