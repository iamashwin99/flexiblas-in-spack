FROM debian:bullseye

# # which spack version are we using now? Default is develop
# # but other strings can be given to the docker build command
# # (for example docker build --build-arg SPACK_VERSION=v0.16.2)
ARG SPACK_VERSION=releases/v0.18
ARG FLEXIBLAS_VERSION=3.0.4
RUN echo "Building with spack version ${SPACK_VERSION}"

# Any extra packages to be installed in the host
ARG EXTRA_PACKAGES
RUN echo "Installing EXTRA_PACKAGES ${EXTRA_PACKAGES} on container host"

# general environment for docker
ENV SPACK_ROOT=/home/user/spack \
	  SPACK=/home/user/spack/bin/spack \
	  FORCE_UNSAFE_CONFIGURE=1

RUN apt-get -y update
# Convenience tools, if desired for debugging etc
# RUN apt-get -y install wget time nano vim emacs git

# From https://github.com/ax3l/dockerfiles/blob/master/spack/base/Dockerfile:
# install minimal spack dependencies
RUN apt-get install -y --no-install-recommends \
              autoconf \
              build-essential \
              ca-certificates \
              coreutils \
              curl \
              environment-modules \
	            file \
              gfortran \
              git \
              openssh-server \
              python \
              unzip \
              vim \
           && rm -rf /var/lib/apt/lists/*

# load spack environment on login
RUN echo "source $SPACK_ROOT/share/spack/setup-env.sh" \
           > /etc/profile.d/spack.sh

RUN adduser user
USER user
WORKDIR /home/user

# install spack
RUN git clone https://github.com/spack/spack.git
# default branch is develop
RUN cd spack && git checkout $SPACK_VERSION

# # show which version we use
RUN $SPACK --version

# copy our package.py into the spack tree
COPY spack/package.py $SPACK_ROOT/var/spack/repos/builtin/packages/flexiblas/package.py
RUN ls -l $SPACK_ROOT/var/spack/repos/builtin/packages/flexiblas

# Install and test flexiblas via spack

RUN . $SPACK_ROOT/share/spack/setup-env.sh && \
      # display specs of upcoming spack installation:
      spack spec flexiblas@${FLEXIBLAS_VERSION} && \
      # run the spack installation (adding it to the environment):
      spack install flexiblas@${FLEXIBLAS_VERSION} && \
      # run spack smoke tests for flexiblas. We get an error if any of the fails:
      spack test run --alias test_serial flexiblas && \
      # display output from smoke tests (just for information):
      spack test results -l test_serial && \
      # show which flexiblas version we use (for convenience):
      spack load flexiblas && flexiblas --version


# Provide bash in case the image is meant to be used interactively
CMD /bin/bash -l
