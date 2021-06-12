FROM fedora-minimal:latest AS src
RUN microdnf install -y python python-pip --nodocs --setopt install_weak_deps=0 && \
    microdnf clean all -y
WORKDIR /build
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt
ENTRYPOINT [ "bash" ]
