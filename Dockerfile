FROM phusion/baseimage:latest

WORKDIR /opt/

RUN add-apt-repository ppa:jonathonf/ffmpeg-3 -y
RUN apt-get update
RUN apt-get install software-properties-common apt-transport-https curl -y
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y
RUN echo "Installing Git..."
RUN apt-get install git -y
RUN echo "Installing .NET Core..."
RUN apt-get install dotnet-sdk-2.1 -y
RUN echo "Installing prerequisites..."
RUN apt-get install libopus0 opus-tools libopus-dev libsodium-dev ffmpeg tmux python python3-pip redis-server -y
RUN curl -sL  https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
RUN chmod a+rx /usr/local/bin/youtube-dl

RUN git clone -b 1.9 --recursive --depth 1 https://gitlab.com/Kwoth/nadekobot.git

RUN cd nadekobot && dotnet restore
RUN cd nadekobot && dotnet build --configuration Release

ADD run.sh /opt/

CMD ["sh","/opt/run.sh"]
