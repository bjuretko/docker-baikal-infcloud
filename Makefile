default: build

image = alpine-infcloud-baikal
tag = 3.9-0.13.1-0.5.2
timezone = Europe/Berlin

build:
	docker build \
			--build-arg TIMEZONE=$(timezone) \
			--tag "$(image):$(tag)" \
			--tag "$(image):latest" .

export:
	docker image save --output "$(image).$(tag).tgz" "$(image):$(tag)"

run:
	docker run \
			--publish 8800:8800 \
			--volume "$$(pwd)/baikal:/var/www/baikal/Specific" \
			$(image)
