FROM debian:trixie-slim@sha256:a72b4433de1cf7d6bae0c4cee74d0547f58601a643b3375f070c51600d63b6b2

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
