FROM debian:bullseye-slim

ARG SYSTEM_NAME
ENV SYSTEM_NAME=${SYSTEM_NAME}

RUN apt-get update && apt-get install -y sbcl curl gnupg
RUN useradd -ms /bin/bash lisp
USER lisp
WORKDIR /home/lisp

RUN curl -O https://beta.quicklisp.org/quicklisp.lisp
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp.asc
RUN curl -O https://beta.quicklisp.org/release-key.txt
RUN gpg --import release-key.txt
RUN gpg --verify quicklisp.lisp.asc quicklisp.lisp


RUN sbcl --non-interactive \
       --load quicklisp.lisp \
       --eval '(quicklisp-quickstart:install)' \
       --eval '(ql::without-prompting (ql:add-to-init-file))'

COPY . /home/lisp/common-lisp/${SYSTEM_NAME}/
RUN ls /home/lisp/common-lisp/${SYSTEM_NAME}

RUN sbcl --non-interactive --eval '(ql:quickload (sb-ext:posix-getenv "SYSTEM_NAME"))'
CMD bash
