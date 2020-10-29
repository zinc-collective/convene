FROM ubuntu:focal

COPY *.sh /
RUN /install-jitsi-meet.sh

EXPOSE 80 443 8080

CMD /run-jitsi-services.sh
