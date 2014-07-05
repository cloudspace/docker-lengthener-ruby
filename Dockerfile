#################################################################
#
#                    ##        .
#              ## ## ##       ==
#           ## ## ## ##      ===
#       /""""""""""""""""\___/ ===
#  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
#       \______ o          __/
#         \    \        __/
#          \____\______/
#
#################################################################

FROM ubuntu:saucy
MAINTAINER Michael Orr <michael@cloudspace.com>

ADD config_files/sources.list /etc/apt/sources.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor openssh-server pwgen vim

# basic ssh setup
RUN mkdir -p /var/run/sshd
ADD config_files/ssh_config /etc/ssh/ssh_config
ADD config_files/sshd_config /etc/ssh/sshd_config
ADD config_files/supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf

# Install ruby and rails
RUN apt-get install -y git-core curl zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties make
# Set default Git user
RUN git config --global user.name "Cloudspace"
RUN git config --global user.email "info@cloudspace.com"
# Install rbenv
RUN git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
RUN echo $PATH
# Add rbenv paths and eval to .bashrc and .bash_profile (needed in login/non-login shells)
RUN echo -e 'export PATH="./bin:$HOME/.rbenv/bin:$PATH"\neval "$(rbenv init -)"' | tee ~/.bash_profile ~/.bashrc
RUN . ~/.bash_profile
RUN echo $PATH
# Install rbenv plugns
RUN git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN git clone git://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
RUN git clone git://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update
RUN git clone git://github.com/dcarley/rbenv-sudo.git ~/.rbenv/plugins/rbenv-sudo
# Install and set default ruby version
RUN cd ~/.rbenv && ~/.rbenv/bin/rbenv install --keep 2.1.2
RUN cd ~/.rbenv && ~/.rbenv/bin/rbenv global 2.1.2
#RUN cd ~/.rbenv && ruby -v
RUN echo -e "install: --no-ri --no-rdoc\nupdate: --no-ri --no-rdoc" > ~/.gemrc

ADD bash_scripts/setup.sh /setup.sh
ADD bash_scripts/run.sh /run.sh

ADD ruby_scripts/run.rb /run.rb

RUN chmod 755 /*.sh
RUN chmod 755 /*.rb

EXPOSE 22

CMD ["/run.sh"]