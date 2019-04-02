dimage?=gcr.io/vspegypt/trips

docker_build:
	docker build -t ${dimage} -f ./build/Dockerfile .
