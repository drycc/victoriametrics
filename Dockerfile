ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ARG DRYCC_UID=1001 \
  DRYCC_GID=1001 \
  DRYCC_HOME_DIR=/data \
  NODE_EXPORTER_VERSION="1.9.1" \
  KUBE_STATE_METRICS="2.17.0" \
  VICTORIAMETRICS_VERSION="1.125.1"

RUN groupadd drycc --gid ${DRYCC_GID} \
  && useradd drycc -u ${DRYCC_UID} -g ${DRYCC_GID} -s /bin/bash -m -d ${DRYCC_HOME_DIR} \
  && install-stack node_exporter $NODE_EXPORTER_VERSION \
  && install-stack kube-state-metrics $KUBE_STATE_METRICS \
  && install-stack victoriametrics $VICTORIAMETRICS_VERSION \
  && rm -rf \
      /usr/share/doc \
      /usr/share/man \
      /usr/share/info \
      /usr/share/locale \
      /var/lib/apt/lists/* \
      /var/log/* \
      /var/cache/debconf/* \
      /etc/systemd \
      /lib/lsb \
      /lib/udev \
      /usr/lib/`echo $(uname -m)`-linux-gnu/gconv/IBM* \
      /usr/lib/`echo $(uname -m)`-linux-gnu/gconv/EBC* \
      /var/cache/apk/* /root/.gem/ruby/*/cache/*.gem \
  && bash -c "mkdir -p /usr/share/man/man{1..8}"

VOLUME ${DRYCC_HOME_DIR}

USER ${DRYCC_UID}
