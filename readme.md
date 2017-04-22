## Build image

	docker build -t nginx-php .

## Run

	docker-compose up

docker-compose.yml example:

	version: '2'
	services:
	  web:
	    image: nginx-php
	    hostname: my.website
	    ports:
	      - "80:80"
	    volumes:
	      - .:/var/www
	    links:
	     - fixture
	  fixture:
	    image: mysql:latest
	    ports:
	      - "3306:3306"
	    environment:
	      MYSQL_DATABASE: fixture
	      MYSQL_ROOT_PASSWORD: root      
