FROM codes-core

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

WORKDIR "/opt/"
RUN git clone https://github.com/kli1221/codesvis

WORKDIR "/opt/codesvis"
RUN npm install
RUN npm start