FROM fedora:latest AS src-latest
RUN dnf install -y python python-pip --nodocs --setopt install_weak_deps=False && \
    dnf clean all -y

FROM fedora:latest as src-env
ENV PATH /usr/local:$PATH

FROM src-env AS src-39
RUN dnf install dnf-plugins-core wget xz -y --nodocs --setopt install_weak_deps=False && \
    dnf builddep python3 -y --nodocs --setopt install_weak_deps=False && \ 
    dnf clean all -y
WORKDIR /src
# Heavily copying from https://github.com/docker-library/python/blob/master/3.8/bullseye/Dockerfile
ENV LANG C.UTF-8
ENV PYTHON_VERSION 3.9.9
RUN set -ex && \
    wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" && \
    mkdir python && \
    tar -xJC python --strip-components=1 -f python.tar.xz && \
    rm python.tar.xz && \
    cd python && \
    ./configure \
        --prefix=/usr/local \
        --enable-loadable-sqlite-extensions \
		--enable-optimizations \
        --enable-shared \
		--enable-option-checking=fatal \
		--with-system-expat \
		--with-system-ffi && \
    make install
WORKDIR /build
RUN set -ex && rm -rf /src
COPY /python/lib_config.sh ./
RUN set -ex && \
    # set convience symbolic links for pip and python
    ln -s /usr/local/bin/python3.9 /usr/local/bin/python && \
    ln -s /usr/local/bin/pip3.9 /usr/local/bin/pip && \
    chmod +x lib_config.sh && \
    ./lib_config.sh && \
     ldconfig
RUN set -ex && find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name '*.a' \) \) \
			-o \( -type f -a -name 'wininst-*.exe' \) \
		\) -exec rm -rf '{}' +

FROM src-env AS src-38
RUN dnf install dnf-plugins-core wget xz -y --nodocs --setopt install_weak_deps=False && \
    dnf builddep python3 -y --nodocs --setopt install_weak_deps=False && \ 
    dnf clean all -y
WORKDIR /src
ENV LANG C.UTF-8
ENV PYTHON_VERSION 3.8.12
# Heavily copying from https://github.com/docker-library/python/blob/master/3.8/bullseye/Dockerfile
RUN set -ex && \
    wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" && \
    mkdir python && \
    tar -xJC python --strip-components=1 -f python.tar.xz && \
    rm python.tar.xz && \
    cd python && \
    ./configure \
        --prefix=/usr/local \
        --enable-loadable-sqlite-extensions \
		--enable-optimizations \
        --enable-shared \
		--enable-option-checking=fatal \
		--with-system-expat \
		--with-system-ffi && \
    make install
WORKDIR /build
RUN set -ex && rm -rf /src
COPY /python/lib_config.sh ./
RUN set -ex && \
    # set convience symbolic links for pip and python
    ln -s /usr/local/bin/python3.8 /usr/local/bin/python && \
    ln -s /usr/local/bin/pip3.8 /usr/local/bin/pip && \
    chmod +x lib_config.sh && \
    ./lib_config.sh && \
     ldconfig
RUN set -ex && find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name '*.a' \) \) \
			-o \( -type f -a -name 'wininst-*.exe' \) \
		\) -exec rm -rf '{}' +

FROM fedora:latest AS build-req
WORKDIR /build
COPY /python/lib_config.sh ./
COPY python/requirements.txt ./requirements.txt
RUN chmod +x lib_config.sh

FROM src-latest as build-latest
COPY --from=build-req build/requirements.txt /build/
RUN pip install --no-cache-dir -r /build/requirements.txt && rm /build/requirements.txt

FROM fedora:latest as build-39
COPY --from=build-req build/. /build/
COPY --from=src-39 /usr/local/. /usr/local/
ENV PATH /usr/local/bin:$PATH
RUN set -ex && \
    ./build/lib_config.sh && \
     ldconfig
RUN pip install --no-cache-dir -r /build/requirements.txt && rm -rf /build/
ENTRYPOINT [ "python" ]

FROM fedora:latest as build-38
COPY --from=build-req build/. /build/
COPY --from=src-38 /usr/local/. /usr/local/
ENV PATH /usr/local/bin:$PATH
RUN set -ex && \
    ./build/lib_config.sh && \
     ldconfig
RUN pip install --no-cache-dir -r /build/requirements.txt && rm -rf /build/
ENTRYPOINT [ "python" ]