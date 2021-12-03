FROM eosio/eosio:v2.1.0

RUN apt -qy update && \
    apt -qy upgrade && \
    apt -qy install \
        build-essential curl \ 
        git cmake netcat jq \ 
        supervisor && \
    apt clean all

RUN mkdir /app
WORKDIR /app

RUN wget https://github.com/eosio/eosio.cdt/releases/download/v1.8.0/eosio.cdt_1.8.0-1-ubuntu-18.04_amd64.deb
RUN apt install -qy ./eosio.cdt_1.8.0-1-ubuntu-18.04_amd64.deb
RUN rm ./eosio.cdt_1.8.0-1-ubuntu-18.04_amd64.deb

RUN git clone https://github.com/EOSIO/eos && \
    cd eos && \
    git checkout release/2.1.x && \
    cd contracts/contracts && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make

RUN git clone https://github.com/EOSIO/eosio.contracts && \
    cd eosio.contracts && \
    git checkout release/1.9.x && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make

COPY . .
COPY eosio-wallet /root/eosio-wallet
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod +x nodeos.sh
RUN chmod +x eosio-boot.sh

EXPOSE 8888
EXPOSE 8080

ENTRYPOINT [ "/usr/bin/supervisord" ]