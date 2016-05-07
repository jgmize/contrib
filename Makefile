all: push

TAG ?= latest
PREFIX ?= quay.io/mozmar/ubuntu-slim-python
BUILD_IMAGE ?= ubuntu-build-python
TAR_FILE ?= rootfs-python.tar

container:
	docker build -t $(BUILD_IMAGE) -f Dockerfile.build .
	docker create --name $(BUILD_IMAGE) $(BUILD_IMAGE)
	docker export $(BUILD_IMAGE) > $(TAR_FILE)
	docker rm $(BUILD_IMAGE)
	docker build -t $(PREFIX):$(TAG) .

push: container
	docker push $(PREFIX):$(TAG)

clean:
	docker rmi -f $(PREFIX):$(TAG)
	docker rmi -f $(BUILD_IMAGE)
	rm $(TAR_FILE)
