FROM condaforge/miniforge3:latest

ARG CONDA_ENV=deploy
ARG ROQ_CHANNEL=unstable

ARG CONDA_DIR=/opt/conda
ARG CONDA=$CONDA_DIR/bin/conda
ARG CONDA_ENV_DIR=$CONDA_DIR/envs/$CONDA_ENV
ARG ROQ_RUN_DIR=/run/roq
ARG ROQ_LOG_DIR=/var/log/roq
ARG ROQ_FLAGS_DIR=/etc/roq
ARG ROQ_CONF_DIR=/config
ARG ROQ_DATA_DIR=/data
ARG BIN_DIR=/usr/local/bin
ARG ROQ_LAUNCH=$BIN_DIR/roq-launch.sh
ARG SUPERVISORD=$BIN_DIR/supervisord.sh

RUN conda create --yes --name $CONDA_ENV

RUN conda install --yes --quiet --name $CONDA_ENV --channel https://roq-trading.com/conda/$ROQ_CHANNEL \
  roq-deribit \
  roq-fix-bridge \
  roq-journal \
  roq-position-manager \
  supervisor

RUN mkdir -p $ROQ_RUN_DIR $ROQ_LOG_DIR $ROQ_FLAGS_DIR $ROQ_CONF_DIR $ROQ_DATA_DIR

RUN printf "#!/usr/bin/env bash\nBIN=\$1\nTGT=\$2\nshift 2\n$CONDA run --name $CONDA_ENV \$BIN --flagfile $CONDA_ENV_DIR/share/\$BIN/flags/\$TGT/flags.cfg \$@\n" > $ROQ_LAUNCH

RUN printf "#!/usr/bin/env bash\n$CONDA run --name $CONDA_ENV supervisord -c /etc/supervisord.conf \$@\n" > $SUPERVISORD

RUN chmod +x $SUPERVISORD $ROQ_LAUNCH

ADD config/supervisord.conf /etc/supervisord.conf

EXPOSE 1234/tcp 9001/tcp

# note!
#   reasonable flags for this demo
#   you may override these by mounting your own configuration into the flags directory

ADD config/*.cfg $ROQ_FLAGS_DIR

# note!
#   although these are reasonable config examples, **THE CREDENTIALS ARE NOT VALID**
#   **YOU SHOULD MOUNT YOUR OWN CONFIGURATION** into the config directory

COPY config/keys.json $ROQ_CONF_DIR
ADD config/*.toml $ROQ_CONF_DIR

CMD /usr/local/bin/supervisord.sh --nodaemon --pidfile /run/supervisord
