FROM ubuntu:14.04

# Build or install
ARG BUILD="true"

# RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list

# Update the OS
RUN apt-get update

# Upgrade the OS
RUN apt-get -y upgrade

# Install useful tools
RUN apt-get install -y vim build-essential git wget
# firefox
RUN apt-get autoremove

# Add user for future work
RUN useradd -ms /bin/bash conda-user

# select created user
USER conda-user

# Install miniconda
RUN wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O \ 
  $HOME/miniconda.sh
RUN bash $HOME/miniconda.sh -b -p $HOME/miniconda
RUN rm $HOME/miniconda.sh
RUN echo 'export PATH=$PATH:$HOME/miniconda/bin' >> $HOME/.bashrc 
RUN $HOME/miniconda/bin/conda config --set always_yes yes --set changeps1 no
RUN $HOME/miniconda/bin/conda update -q conda
RUN $HOME/miniconda/bin/conda info -a

# Install conda-build
RUN $HOME/miniconda/bin/conda install conda-build==1.21.7

# Install IPython, Jupyter and Pip
RUN $HOME/miniconda/bin/conda install ipython jupyter pip

# Install libraries and packages from Misc
## Clone the repository
RUN [ $BUILD = "true" ] && git clone https://github.com/Statiskit/Misc.git $HOME/Misc || [ $BUILD = "false" ]
RUN [ $BUILD = "true" ] && git -C $HOME/Misc pull || [ $BUILD = "false" ]

## Create a file for anaconda upload
RUN touch $HOME/upload.sh
RUN echo "set -e" >> $HOME/upload.sh
RUN [ $BUILD = "true" ] && echo "$HOME/miniconda/bin/conda install anaconda-client" >> $HOME/upload.sh || [ $BUILD = "false" ]

## Build libboost recipe
RUN [ $BUILD = "true" ] && $HOME/miniconda/bin/conda build $HOME/Misc/libboost -c statiskit || [ $BUILD = "false" ]
RUN [ $BUILD = "true" ] && echo "anaconda upload \`conda build $HOME/Misc/libboost --output\` --user statiskit --force" >> $HOME/upload.sh || [ $BUILD = "false" ]

## Build python-scons recipe
RUN [ $BUILD = "true" ] && $HOME/miniconda/bin/conda build $HOME/Misc/python-scons -c statiskit || [ $BUILD = "false" ]
RUN [ $BUILD = "true" ] && echo "anaconda upload \`conda build $HOME/Misc/python-scons --output\` --user statiskit --force" >> $HOME/upload.sh || [ $BUILD = "false" ]

## Build python-parse recipe
RUN [ $BUILD = "true" ] && $HOME/miniconda/bin/conda build $HOME/Misc/python-parse -c statiskit || [ $BUILD = "false" ]
RUN [ $BUILD = "true" ] && echo "anaconda upload \`conda build $HOME/Misc/python-parse --output\` --user statiskit --force" >> $HOME/upload.sh || [ $BUILD = "false" ]

## Finalize file for anaconda upload
RUN [ $BUILD = "true" ] && echo "rm -rf $HOME/Misc" >> $HOME/upload.sh || [ $BUILD = "false" ]
RUN [ $BUILD = "true" ] && echo "$HOME/miniconda/bin/conda remove anaconda-client" >> $HOME/upload.sh || [ $BUILD = "false" ]
RUN [ $BUILD = "true" ] && echo "$HOME/miniconda/bin/conda env remove -n _build " >> $HOME/upload.sh || [ $BUILD = "false" ]
RUN [ $BUILD = "true" ] && echo "$HOME/miniconda/bin/conda env remove -n _test " >> $HOME/upload.sh || [ $BUILD = "false" ]
RUN echo "$HOME/miniconda/bin/conda clean --all" >> $HOME/upload.sh
RUN echo "rm -rf $HOME/miniconda/pkgs" >> $HOME/upload.sh
RUN echo "rm $HOME/upload.sh" >> $HOME/upload.sh
RUN [ $BUILD = "false" ] && /bin/bash $HOME/upload.sh ||[ $BUILD = "true" ]

WORKDIR /home/conda-user
