FROM ubuntu

ENTRYPOINT ["/bin/bash"]
RUN apt-get update
RUN apt-get install -y git python3.6 python3-pip python3-dev libeigen3-dev
RUN pip3 install pybind11 numpy sklearn pandas
RUN alias python3=python3.6

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan sphere.cs.ucdavis.edu > /root/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa.pub

WORKDIR "/opt"
RUN git clone https://sphere.cs.ucdavis.edu/kelli/hpc-vast
RUN git clone hgit clone https://github.com/HAVEX/ross-vis-server

WORKDIR "/opt/hpc-vast/dim_reduction/inc_pca"
RUN c++ -O3 -Wall -mtune=native -march=native -shared -std=c++11 -I/usr/include/eigen3/ -fPIC `python3 -m pybind11 --includes` inc_pca.cpp inc_pca_wrap.cpp -o inc_pca_cpp`python3-config --extension-suffix`

WORKDIR "/opt/hpc-vast/dim_reduction/prog_inc_pca"
RUN c++ -O3 -Wall -mtune=native -march=native -shared -std=c++11 -I../inc_pca/ -I/usr/include/eigen3/ -fPIC `python3 -m pybind11 --includes` ../inc_pca/inc_pca.cpp prog_inc_pca.cpp prog_inc_pca_wrap.cpp -o prog_inc_pca_cpp`python3-config --extension-suffix`

WORKDIR "/opt/hpc-vast/change_point_detection/ffstream"
RUN c++ -O3 -Wall -shared -std=c++11 -I/usr/include/eigen3/  -fPIC `python3 -m pybind11 --includes` detector.cpp utils.cpp fff.cpp aff.cpp affcd.cpp aff_wrap.cpp -o aff_cpp`python3-config --extension-suffix`

WORKDIR "/opt/ross-vis-server"
RUN pip3 install -r requirement.txt

