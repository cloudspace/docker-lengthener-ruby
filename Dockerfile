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

FROM cloudspace/microbase-ruby:0.2
MAINTAINER Michael Orr <michael@cloudspace.com>

ADD ruby_scripts/run.rb /run.rb
RUN chmod 755 /*.rb
ADD http://geec-client.s3.amazonaws.com/runner /runner
RUN chmod a+x /runner
