FROM condaforge/miniforge3:latest

ARG CONDA_ENV=deploy
ARG ROQ_URL=https://roq-trading.com/conda/unstable

RUN conda create --yes --name $CONDA_ENV

RUN conda install --yes --quiet --name $CONDA_ENV --channel $ROQ_URL \
  roq-deribit \
  roq-fix-bridge \
  roq-journal \
  roq-position-manager

RUN conda list --name $CONDA_ENV | grep roq

RUN mkdir -p /etc/roq/{deribit,fix-bridge}
RUN mkdir -p /var/lib/roq/{deribit,fix-bridge}
RUN mkdir -p /var/log/roq/{deribit,fix-bridge}

RUN ls -ahl /opt/conda/envs/$CONDA_ENV/share/roq-deribit
