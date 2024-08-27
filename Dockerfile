FROM condaforge/miniforge3:latest

ARG CONDA_ENV=deploy
ARG ROQ_CHANNEL=unstable

ARG CONDA_DIR=/opt/conda
ARG CONDA_ENV_DIR=${CONDA_DIR}/envs/$CONDA_ENV
ARG ROQ_CONF_DIR=/etc/roq
ARG ROQ_BIN_DIR=/usr/local/bin
ARG ROQ_LAUNCH=$ROQ_BIN_DIR/roq-launch.sh

RUN conda create --yes --name $CONDA_ENV

RUN conda install --yes --quiet --name $CONDA_ENV --channel https://roq-trading.com/conda/$ROQ_CHANNEL \
  roq-deribit \
  roq-fix-bridge \
  roq-journal \
  roq-position-manager \
  supervisor

RUN bash -c "mkdir -p ${ROQ_CONF_DIR}/{deribit,fix-bridge}"

RUN printf "#!/usr/bin/env bash\nBIN=\$1\nTGT=\$2\nshift 2\nsource $CONDA_DIR/bin/activate $CONDA_ENV\n\$BIN --flagfile $CONDA_ENV_DIR/share/\$BIN/flags/\$TGT/flags.cfg,$ROQ_CONF_DIR/\$BIN/flags.cfg \$@\n" > $ROQ_LAUNCH

RUN chmod +x $ROQ_LAUNCH

COPY scripts/supervisord.conf /etc/supervisord.conf

EXPOSE 9001

CMD $CONDA_ENV_DIR/bin/supervisord -c /etc/supervisord.conf
