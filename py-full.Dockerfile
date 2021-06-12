FROM fedora:latest AS src
RUN dnf install -y python python-pip --nodocs --setopt install_weak_deps=False && \
    dnf clean all -y
WORKDIR /build
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt
ENTRYPOINT [ "bash" ]
