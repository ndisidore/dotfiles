FROM debian:trixie-slim@sha256:a29215f6a35e51e22adffa17f89e9d2ef06214e64a2bad10d765c46aea49f11f

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
