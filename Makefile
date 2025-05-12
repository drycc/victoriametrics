SHELL := /bin/bash

# all monitor components share/use the following targets/exports
BUILD_TAG ?= git-$(shell git rev-parse --short HEAD)
DRYCC_REGISTRY ?= ${DEV_REGISTRY}
IMAGE_PREFIX ?= drycc
PLATFORM ?= linux/amd64,linux/arm64

include versioning.mk

TEST_ENV_PREFIX := podman run --rm -v ${CURDIR}:/bash -w /bash ${DEV_REGISTRY}/drycc/python-dev

build: podman-build
push: podman-push
deploy: podman-build podman-push

check-podman:
	@if [ -z $$(which podman) ]; then \
		echo "Missing \`podman\` client which is required for development"; \
		exit 2; \
	fi

podman-build:
	podman build --build-arg CODENAME=${CODENAME} -t ${IMAGE} .
	podman tag ${IMAGE} ${MUTABLE_IMAGE}

podman-buildx:
	podman buildx build --build-arg CODENAME=${CODENAME} --platform ${PLATFORM} -t ${IMAGE} --push .

clean: check-podman
	podman rmi $(IMAGE)
	
test: podman-build

.PHONY: build push podman-build clean deploy test

build-all:
	podman build -t ${DRYCC_REGISTRY}/${IMAGE_PREFIX}/victoriametrics:${VERSION}

push-all:
	podman push ${DRYCC_REGISTRY}/${IMAGE_PREFIX}/victoriametrics:${VERSION}
