IMG_NAME = hematite/python
FULL_IMG_NAME = ${IMG_NAME}-base
SLIM_IMG_NAME = ${IMG_NAME}-slim
LAMBDA_IMG_NAME = ${IMG_NAME}-lambda
IMG_R_NAME = hematite/r
SLIM_R_IMG_NAME = ${IMG_NAME}-tidyish

build: build-py-slim build-py-full build-r-slim

build-py-full:
	docker build . -f py-full.Dockerfile -t ${FULL_IMG_NAME}

build-py-slim:
	docker build . -f py-Dockerfile-slim -t ${MINIMAL_IMG_NAME}
build-r-slim:
	docker build . -f r-slim.Dockerfile --target tidy -t ${SLIM_R_IMG_NAME}
