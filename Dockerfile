FROM phusion/baseimage:0.9.17

MAINTAINER jshridha <jshridha@gmail.com>

RUN apt-get update && apt-get install -q -y --no-install-recommends \
    bsd-mailx \
    motion \
    mutt \
    ssmtp \
    x264 \
	supervisor

RUN add-apt-repository -y ppa:kirillshkrogalev/ffmpeg-next && \
	apt-get update && \
	apt-get install ffmpeg v4l-utils python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev
	
RUN pip install motioneye

RUN mkdir -p /var/lib/motioneye
	
# Copy and scripts
COPY script/* /usr/local/bin/ 

ADD supervisor/*.conf /etc/supervisor/conf.d/

ADD config/ /config_orig

EXPOSE 8081
 
VOLUME ["/var/lib/motion"]
 
WORKDIR /var/lib/motion

RUN usermod -u 99 nobody && \
usermod -g 100 nobody

CMD ["/usr/bin/supervisord, /etc/supervisor/supervisord.conf"]
