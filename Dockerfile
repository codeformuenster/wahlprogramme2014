FROM ubuntu:13.10

# Set locale
RUN locale-gen --no-purge de_DE.UTF-8
ENV LC_ALL de_DE.UTF-8

RUN apt-get update && apt-get -y install ruby
RUN gem install bundler --no-ri --no-rdoc

ADD Gemfile /var/www/wahlprogramme/Gemfile
ADD Gemfile.lock /var/www/wahlprogramme/Gemfile.lock
WORKDIR /var/www/wahlprogramme
RUN bundle -j 4

ADD parser.rb /var/www/wahlprogramme/

ENTRYPOINT ["ruby", "/var/www/wahlprogramme/parser.rb"]
