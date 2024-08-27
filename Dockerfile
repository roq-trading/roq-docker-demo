FROM condaforge/miniforge3:latest

ARG CONDA_ENV=deploy
ARG ROQ_CHANNEL=unstable

ARG CONDA_DIR=/opt/conda
ARG CONDA=$CONDA_DIR/bin/conda
ARG CONDA_ENV_DIR=$CONDA_DIR/envs/$CONDA_ENV
ARG ROQ_RUN_DIR=/run/roq
ARG ROQ_CONF_DIR=/etc/roq
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

RUN mkdir -p $ROQ_RUN_DIR

RUN mkdir -p $ROQ_CONF_DIR

RUN printf "#!/usr/bin/env bash\nBIN=\$1\nTGT=\$2\nshift 2\n$CONDA run --name $CONDA_ENV \$BIN --flagfile $CONDA_ENV_DIR/share/\$BIN/flags/\$TGT/flags.cfg --config_file $CONDA_ENV_DIR/share/\$BIN/config.toml \$@\n" > $ROQ_LAUNCH
RUN chmod +x $ROQ_LAUNCH

RUN printf "#!/usr/bin/env bash\n$CONDA run --name $CONDA_ENV supervisord -c /etc/supervisord.conf \$@\n" > $SUPERVISORD
RUN chmod +x $SUPERVISORD

ADD scripts/supervisord.conf /etc/supervisord.conf

EXPOSE 9001

# note! these are config examples, you should mount your own configuration into this directory
ADD scripts/*.toml $ROQ_CONF_DIR

CMD /usr/local/bin/supervisord.sh
