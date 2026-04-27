DOCKER_IMAGE := georgelpreput/marker

CPU_VERSION := v$(shell sed -n 's/^version = "\([^"]*\)".*/\1/p' pyproject-cpu.toml)
GPU_VERSION := v$(shell sed -n 's/^version = "\([^"]*\)".*/\1/p' pyproject-gpu.toml)

DOCKER_BUILD := docker build --no-cache --provenance=false

# ── Build targets ─────────────────────────────────────────────────────────────

.PHONY: build-gpu-amd64 build-cpu-amd64 build-gpu-arm64 build-cpu-arm64

build-gpu-amd64:
	$(DOCKER_BUILD) --platform linux/amd64 \
		-t $(DOCKER_IMAGE):$(GPU_VERSION)-gpu-amd64 \
		-f Dockerfile.gpu-amd64 .

build-cpu-amd64:
	$(DOCKER_BUILD) --platform linux/amd64 \
		-t $(DOCKER_IMAGE):$(CPU_VERSION)-cpu-amd64 \
		-f Dockerfile.cpu-amd64 .

build-gpu-arm64:
	$(DOCKER_BUILD) --platform linux/arm64 \
		-t $(DOCKER_IMAGE):$(GPU_VERSION)-gpu-arm64 \
		-f Dockerfile.gpu-arm64 .

build-cpu-arm64:
	$(DOCKER_BUILD) --platform linux/arm64 \
		-t $(DOCKER_IMAGE):$(CPU_VERSION)-cpu-arm64 \
		-f Dockerfile.cpu-arm64 .

# ── Push targets ──────────────────────────────────────────────────────────────

.PHONY: push-gpu-amd64 push-cpu-amd64 push-gpu-arm64 push-cpu-arm64

push-gpu-amd64:
	docker push $(DOCKER_IMAGE):$(GPU_VERSION)-gpu-amd64

push-cpu-amd64:
	docker push $(DOCKER_IMAGE):$(CPU_VERSION)-cpu-amd64

push-gpu-arm64:
	docker push $(DOCKER_IMAGE):$(GPU_VERSION)-gpu-arm64

push-cpu-arm64:
	docker push $(DOCKER_IMAGE):$(CPU_VERSION)-cpu-arm64

# ── Manifest targets ──────────────────────────────────────────────────────────

.PHONY: manifest-cpu manifest-gpu

manifest-cpu:
	$(eval ARM64 := $(DOCKER_IMAGE):$(CPU_VERSION)-cpu-arm64)
	$(eval AMD64 := $(DOCKER_IMAGE):$(CPU_VERSION)-cpu-amd64)
	for TAG in \
		$(DOCKER_IMAGE):$(CPU_VERSION)-cpu \
		$(DOCKER_IMAGE):latest-cpu \
		$(DOCKER_IMAGE):latest; do \
		docker manifest rm $$TAG 2>/dev/null || true; \
		docker manifest create $$TAG $(ARM64) $(AMD64); \
		docker manifest push $$TAG; \
	done

manifest-gpu:
	$(eval ARM64 := $(DOCKER_IMAGE):$(GPU_VERSION)-gpu-arm64)
	$(eval AMD64 := $(DOCKER_IMAGE):$(GPU_VERSION)-gpu-amd64)
	for TAG in \
		$(DOCKER_IMAGE):$(GPU_VERSION)-gpu \
		$(DOCKER_IMAGE):latest-gpu; do \
		docker manifest rm $$TAG 2>/dev/null || true; \
		docker manifest create $$TAG $(ARM64) $(AMD64); \
		docker manifest push $$TAG; \
	done
