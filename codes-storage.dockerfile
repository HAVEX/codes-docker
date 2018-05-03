FROM codes-core

ENTRYPOINT ["/bin/bash"]

WORKDIR "/opt"
RUN git clone https://xgitlab.cels.anl.gov/codes/codes-storage-server.git

WORKDIR "/opt/codes-storage-server"
RUN ./prepare.sh
RUN mkdir build
WORKDIR "/opt/codes-storage-server/build"
RUN ../configure PKG_CONFIG_PATH=/opt/codes/install/lib/pkgconfig CC=mpicc CXX=mpicxx CCLD=mpicxx CFLAGS=-g --prefix=/opt/codes-storage-server/install
RUN make -j 4
RUN make install
