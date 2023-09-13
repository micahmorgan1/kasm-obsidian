FROM kasmweb/core-ubuntu-focal:1.14.0-rolling
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Update and install extra packages.
RUN echo "**** install packages ****" && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl libgtk-3-0 libnotify4 libatspi2.0-0 libsecret-1-0 libnss3 desktop-file-utils fonts-noto-color-emoji xdg-utils && \
    apt-get autoclean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# Set version label
ARG OBSIDIAN_VERSION=1.4.11

# Download and install Obsidian
RUN echo "**** download obsidian ****" && \
    curl --location --output obsidian.deb "https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/obsidian_${OBSIDIAN_VERSION}_amd64.deb" && \
    dpkg -i obsidian.deb && \
    sed -i 's,/usr/bin/obsidian,/usr/bin/obsidian --no-sandbox,g' /usr/share/applications/obsidian.desktop && \
    cp /usr/share/applications/obsidian.desktop $HOME/Desktop/ && \
    chmod +x $HOME/Desktop/obsidian.desktop && \
    chown 1000:1000 $HOME/Desktop/obsidian.desktop

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000