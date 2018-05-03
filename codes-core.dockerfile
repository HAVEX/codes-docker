FROM ubuntu

ENTRYPOINT ["/bin/bash"]
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y git autoconf automake cmake mpich doxygen flex bison libtool pkg-config

WORKDIR "/opt"
RUN git clone http://github.com/carothersc/ROSS.git
RUN git clone https://xgitlab.cels.anl.gov/codes/codes
RUN git clone https://github.com/sstsimulator/sst-dumpi
RUN mv sst-dumpi dumpi

WORKDIR "/opt/ROSS"
RUN mkdir build
WORKDIR "/opt/ROSS/build"
RUN /bin/bash -c "ARCH=x86_64 CC=mpicc CXX=mpicxx cmake -DCMAKE_INSTALL_PREFIX=/opt/ROSS/install /opt/ROSS/"
RUN make -j 4
RUN make install

WORKDIR "/opt/dumpi"
RUN mkdir install
RUN /bin/bash -c 'CFLAGS="-DMPICH_SUPPRESS_PROTOTYPES=1 -DHAVE_PRAGMA_HP_SEC_DEF=1"'
RUN ./bootstrap.sh    
RUN ./configure --enable-libdumpi CC=mpicc --prefix=/opt/dumpi/install
RUN make 
RUN make install

WORKDIR "/opt/codes"
RUN mkdir install
RUN mkdir build
RUN ./prepare.sh
WORKDIR "/opt/codes/build"
RUN ../configure --prefix=/opt/codes/install CC=mpicc CXX=mpicxx PKG_CONFIG_PATH=/opt/ROSS/install/lib/pkgconfig --with-dumpi=/opt/dumpi/install
RUN make -j 4
RUN make install
