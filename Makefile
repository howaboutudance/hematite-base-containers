IMG_NAME := hematite/python
TARGET_OS := fedora35
FULL_IMG_NAME := $(IMG_NAME)-base
SLIM_IMG_NAME := ${IMG_NAME}-slim
LAMBDA_IMG_NAME := ${IMG_NAME}-lambda
IMG_R_NAME := hematite/r
SLIM_R_IMG_NAME := ${IMG_NAME}-tidyish

GITHUB_CR_URL := ghcr.io/howaboutudance
PUSH_FULL_IMAGE := $(GITHUB_CR_URL)/$(FULL_IMG_NAME)
PUSH_SLIM_IMAGE := $(GITHUB_CR_URL)/$(SLIM_IMG_NAME)
PODMAN_BUILD = podman build . --squash-all -f python/py-full.Dockerfile

build: build-py-slim build-py-full

build-py-full: py-full-latest py-full-39 py-full-38

py-full-latest: .PHONY
	${PODMAN_BUILD} --target=build-latest -t $(FULL_IMG_NAME):latest
	podman tag ${FULL_IMG_NAME}:latest ${PUSH_FULL_IMAGE}:latest 
	podman tag ${FULL_IMG_NAME}:3.10 ${PUSH_FULL_IMAGE}:3.10 
	podman tag ${FULL_IMG_NAME}:3.10-fedora35 ${PUSH_FULL_IMAGE}:3.10-fedora35 
	podman push ${PUSH_FULL_IMAGE}:latest
	podman push ${PUSH_FULL_IMAGE}:3.10
	podman push ${PUSH_FULL_IMAGE}:3.10-fedora35

py-full-39: .PHONY
	${PODMAN_BUILD} --target=build-39 -t ${FULL_IMG_NAME}:3.9
	podman tag ${FULL_IMG_NAME}:3.9 ${PUSH_FULL_IMAGE}:3.9
	podman tag ${FULL_IMG_NAME}:3.9 ${PUSH_FULL_IMAGE}:3.9-fedora35
	podman push ${PUSH_FULL_IMAGE}:3.9
	podman push ${PUSH_FULL_IMAGE}:3.9-fedora35

py-full-38: .PHONY
	${PODMAN_BUILD} --target build-38 -t ${FULL_IMG_NAME}:3.8
	podman tag ${FULL_IMG_NAME}:3.8 ${PUSH_FULL_IMAGE}:3.8
	podman tag ${FULL_IMG_NAME}:3.8 ${PUSH_FULL_IMAGE}:3.8-fedora35
	podman push ${PUSH_FULL_IMAGE}:3.8
	podman push ${PUSH_FULL_IMAGE}:3.8-fedora35

build-py-slim: .PHONY
	podman build . -f python/py-slim.Dockerfile -t ${SLIM_IMG_NAME}
	podman tag ${SLIM_IMG_NAME}:latest ${PUSH_SLIM_IMAGE}:latest 
	podman tag ${SLIM_IMG_NAME}:latest ${PUSH_SLIM_IMAGE}:3.10 
	podman push ${PUSH_SLIM_IMAGE}:3.10
	podman push ${PUSH_SLIM_IMAGE}:latest

build-r-slim:
	podman build . -f r-slim.Dockerfile --target tidy -t ${SLIM_R_IMG_NAME}

.PHONY: ;
