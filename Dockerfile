FROM debian:bookworm AS base
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get upgrade -y

RUN apt-get install -y sudo
RUN apt-get install -y software-properties-common 
RUN apt-get install -y curl 
RUN apt-get install -y git 
RUN apt-get install -y build-essential
RUN apt-get install -y wget 

RUN wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/ansible.list

RUN apt-get update 
RUN apt-get install -y ansible 

RUN apt-get clean autoclean
RUN apt-get autoremove --yes

FROM base AS me

RUN adduser --gecos "" --disabled-password ladislaff
RUN adduser ladislaff sudo
RUN adduser ladislaff root
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ladislaff
WORKDIR /home/ladislaff

FROM me
COPY --chown=ladislaff:ladislaff ./ ./ansible
WORKDIR /home/ladislaff/ansible

CMD ["sh", "-c", "ansible-playbook local.yml --ask-vault-pass"]
