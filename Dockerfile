FROM ubuntu:23.10 AS base
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get install -y sudo
RUN apt-get install -y software-properties-common 
RUN apt-get install -y curl 
RUN apt-get install -y git 
RUN apt-get install -y build-essential
RUN apt-get install -y wget 
RUN apt-get install -y ansible 
RUN apt-get clean autoclean
RUN apt-get autoremove --yes

FROM base AS me
RUN addgroup --gid 1000 ladislaff
RUN adduser --gecos ladislaff --uid 1000 --gid 1000 --disabled-password ladislaff
USER ladislaff
WORKDIR /home/ladislaff

FROM me
COPY --chown=ladislaff:ladislaff ./ ./ansible
WORKDIR /home/ladislaff/ansible

CMD ["sh", "-c", "ansible-playbook local.yml --ask-vault-pass"]
#CMD ["sh", "ansible-run"]
