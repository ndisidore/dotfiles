FROM debian:trixie-slim@sha256:f6b08b09a05725f9431502d3b5714f5c4576e82c1a84fa1debe0c24a7e0c3ec4

RUN apt-get update -q \
    && apt-get install -qy \
        fish \
        bash \
        curl \
        git \
        gh \
        flatpak \
        sudo \
        locales \
        fontconfig \
        xz-utils \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

# Set up locale
RUN sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Create test user
RUN useradd -m -s /usr/bin/fish testuser \
    && echo 'testuser ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/testuser

USER testuser
WORKDIR /home/testuser
ENV HOME=/home/testuser

# Install mise
RUN curl https://mise.run | sh
ENV PATH="/home/testuser/.local/bin:${PATH}"

ENTRYPOINT ["/usr/bin/fish"]
