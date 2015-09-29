FROM crate:0.50.2

MAINTAINER Datatoknowledge <info@datatoknowledge.it>

RUN sed 's/^\(hosts:[\ ]*\)\(files\)\ \(dns\)$/\1\3 \2/' -i /etc/nsswitch.conf

EXPOSE 4200 4300
