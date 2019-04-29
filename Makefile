default: build

image = alpine-infcloud-baikal
tag = 3.5-0.13.1-0.4.6
timezone = Europe/Berlin

build:
	docker build \
			--build-arg TIMEZONE=$(timezone) \
			--tag "$(image):$(tag)" \
			--tag "$(image):latest" .

run:
	docker run \
			--publish 8800:8800 \
			--volume "$$(pwd)/baikal:/var/www/baikal/Specific" \
			$(image)
