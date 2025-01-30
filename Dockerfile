FROM nimlang/nim:2.2.0

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && apt-get install -y \
    libgl1-mesa-dev \
    xorg-dev \
    libx11-dev \
    libxcursor-dev \
    libxrandr-dev \
    libxinerama-dev \
    tzdata && \
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata


WORKDIR /app
COPY . .
RUN nimble install

CMD ["nim", "c", "--os:windows", "--cpu:amd64", "-d:release", "-o:dist/flappy.exe", "src/nim_flappy.nim"]