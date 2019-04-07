dimage?=gcr.io/vspegypt/tourfax

run: rails s -p 5555

migrate: migrate_dev migrate_test

migrate_dev:
	rails db:migrate; 

migrate_test:
	rails db:migrate RAILS_ENV=test;

createdbuser:
	docker exec -it mysqleight mysql -u root -p123456 -e 'create user "tourfax" identified by "123456"; GRANT ALL ON *.* TO "tourfax"@"%";'

initdb: dropdb createdb

createdb:
	docker exec -it mysqleight mysql -u root -p123456 -e 'create database tourfax; create database tourfax_test;'

dropdb:
	docker exec -it mysqleight mysql -u root -p123456 -e 'drop database tourfax; drop database tourfax_test;'

mysqli:
	docker exec -it mysqleight mysql -u root -p

mysql:
	docker exec -it mysqleight mysql -u tourfax -p -h 127.0.0.1

mysqld:
	docker run --rm -p 3306:3306 -v /Users/ibrahim/srv/git/ugotours/tours.api/data/:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d --name mysqleight mysql/mysql-server --default-authentication-plugin=mysql_native_password

docker_build:
	docker build -t ${dimage} -f ./build/Dockerfile .
