FROM openjdk:8-jdk

RUN apt-get update; \
    apt-get install -y --fix-missing python2.7 net-tools vim python-pip git wget unzip maven mysql-client; \
    wget http://download.java.net/glassfish/4.1/release/glassfish-4.1.zip; \
    unzip glassfish-4.1.zip; \
    pip install sh; \
    wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.39.tar.gz; \
    tar -xvf mysql-connector-java-5.1.39.tar.gz; \
    cp ./mysql-connector-java-5.1.39/mysql-connector-java-5.1.39-bin.jar glassfish4/glassfish/domains/domain1/lib; \
    mkdir /party; \
    mkdir -p /etc/default/tmf/

COPY ./deploy.sh /

VOLUME ["/party", "/etc/default/tmf/"]

EXPOSE 8080 4848

CMD while true; do sleep 1000; done
