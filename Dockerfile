FROM ruby:2.7.0

ENV LANG="en_US.UTF-8" LANGUAGE="en_US:UTF-8" LC_ALL="C.UTF-8"
RUN chmod a+r /etc/resolv.conf

RUN apt-get dist-upgrade -q && \
    apt-get update -q
RUN apt-get install -y --no-install-recommends build-essential lighttpd && \
  apt-get install -y --no-install-recommends libxml++2.6-dev  libraptor2-0 && \
  apt-get install -y --no-install-recommends libxslt1-dev locales software-properties-common cron && \
  apt-get clean
RUN rm -rf /var/lib/apt/lists/* 
RUN locale-gen en_US.UTF-8



RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3 get-pip.py
#RUN pip install extruct[cli]
RUN pip install extruct

RUN gem update --system
RUN gem install rdf-trig rdf-raptor xml-simple parseconfig json rdf-json json-ld json-ld-preloaded rdf-trig rdf-turtle rdf-rdfa sparql  xml-simple nokogiri parseconfig rest-client cgi json-ld-preloaded metainspector addressable

RUN mkdir /TESTS
RUN mkdir /TESTS/tests
WORKDIR /TESTS/tests
COPY ./TESTS/rd* /TESTS/tests/
COPY ./TESTS/fair_metrics_utilities.rb /TESTS/tests/
COPY ./TESTS/config.conf /TESTS/tests/
COPY ./TESTS/env.sh /TESTS/tests/
COPY ./index.rb /TESTS
COPY ./index.html /TESTS
RUN chown -R www-data.www-data /TESTS
COPY ./lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY ./10-cgi.conf /etc/lighttpd/conf-enabled/10-cgi.conf
COPY ./entrypoint.sh /TESTS
COPY crontab /etc/cron.d/wipetmp
RUN chmod 0644 /etc/cron.d/wipetmp
RUN crontab /etc/cron.d/wipetmp
RUN chmod u+x /TESTS/entrypoint.sh
ENTRYPOINT /TESTS/entrypoint.sh && lighttpd -D -f /etc/lighttpd/lighttpd.conf
EXPOSE 8080
