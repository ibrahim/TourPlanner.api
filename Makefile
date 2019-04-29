dimage?=gcr.io/vspegypt/tourfax

run: rails s -p 5555

migrate: migrate_dev migrate_test

migrate_dev:
	rails db:migrate; 

migrate_test:
	rails db:migrate RAILS_ENV=test;

createdbuser:
	docker exec -it mysql mysql -u root -p123456 -e 'create user "tourfax" identified by "123456"; GRANT ALL ON *.* TO "tourfax"@"%";'

initdb: dropdb createdb

services: mysqld redis es mongod

createdb:
	docker exec -it mysql mysql -u root -p123456 -e 'create database tourfax; create database tourfax_test;'

dropdb:
	docker exec -it mysql mysql -u root -p123456 -e 'drop database tourfax; drop database tourfax_test;'

mysql:
	docker exec -it mysql mysql -u root -p123456 -D tourfax

mysqld:
	docker run --rm -p 3306:3306 -v /Users/ibrahim/srv/git/ugotours/tours.api/data/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d --name mysql mysql/mysql-server --default-authentication-plugin=mysql_native_password

mysql_stop:
	docker stop mysql

redis:
	docker run --rm --name redis -p 6379:6379 -v /Users/ibrahim/srv/git/ugotours/tours.api/data/redis:/data -d redis redis-server --appendonly yes

redis_stop:
	docker stop redis

es:
	docker run --rm -d --name elasticsearch -p 9200:9200 -p 9300:9300 -v /Users/ibrahim/srv/git/ugotours/tours.api/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -v /Users/ibrahim/srv/git/ugotours/tours.api/data/elasticsearch:/usr/share/elasticsearch/data -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.7.1


es_stop:
	docker stop elasticsearch
	
mongod:
	docker run --rm -p 27017:27017 -d --name mongodb \
	-v /Users/ibrahim/srv/git/ugotours/tours.api/data/mongodb:/data/db \
    -e MONGO_INITDB_ROOT_USERNAME=admin \
    -e MONGO_INITDB_ROOT_PASSWORD=123456 \
		-e MONGO_INITDB_DATABASE=tourfax \
    mongo

mongo:
	docker exec -it mongodb \
    mongo \
        -u admin \
        -p 123456 \
        --authenticationDatabase admin \
        tourfax

mongo_stop:
	docker stop mongodb

docker_build:
	docker build -t ${dimage} -f ./build/Dockerfile .
