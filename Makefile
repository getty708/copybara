COMMIT_DATE := $(shell git log -1 --format="%cd" --date=short |  sed 's/-//g')
COMMIT_HASH := $(shell git rev-parse --short HEAD)

DOCKER_REMOTE_REPO := getty708/copybara
IMAGE_NAME := ${DOCKER_REMOTE_REPO}
IMAGE_TAG_COMMON := ${COMMIT_DATE}-${COMMIT_HASH}
IMAGE_TAG_BASE := ${IMAGE_TAG_COMMON}-base
IMAGE_TAG_GHA := ${IMAGE_TAG_COMMON}-gha


.PHONY: build-images
build-images: build-base-image build-gha-image

.PHONY: push-images
push-images: push-base-image push-gha-image

.PHONY: build-base-image
build-base-image:
	docker build --rm -t ${IMAGE_NAME}:${IMAGE_TAG_BASE} .

.PHONY: build-gha-image
build-gha-image:
	docker build --rm -t ${IMAGE_NAME}:${IMAGE_TAG_GHA} ./docker-gha \
		--build-arg BASE_IMAGE_TAG=${IMAGE_TAG_BASE}



.PHONY: push-base-image
push-base-image:
	docker push ${IMAGE_NAME}:${IMAGE_TAG_BASE}

.PHONY: push-gha-image
push-gha-image:
	docker push ${IMAGE_NAME}:${IMAGE_TAG_GHA}


.PHINY: run-dev
run-dev:
	docker run -it --rm \
		-v ./docker-gha/config:/root/.ssh/config \
		-v ~/.ssh/keys/ecdsa/id_git:/root/.ssh/id_git \
		getty708/copybara:20240106-5e3d88cf-dev 