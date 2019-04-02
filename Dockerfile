FROM ruby:2.4.2

RUN apt-get update && apt-get install -y libjemalloc-dev libjemalloc1
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.1
