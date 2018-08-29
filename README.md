Wordpress Dev Image
===================

Wordpress (bedrock) running in a single container. 

## Requirements

* Docker

## Usage

Assuming your project is setup like this:

```
.
+-- src
|   +-- plugins
|   +-- themes
+-- docker-compose.yml
```

Add this `docker-compose.yml` file to the root of your project:

```
version: '2'
services:
    wordpress:
        image: bluebamboostudios/wordpress-dev
        volumes:
            - ./src/plugins:/usr/src/wordpress/web/app/plugins
            - ./src/themes:/usr/src/wordpress/web/app/themes
        ports:
            - 8080:80
        depends_on:
            - db
        environment:
            - 'WP_HOME=http://localhost:8080'
            - 'DB_HOST=db'
            - 'DB_NAME=wp_dev'
            - 'DB_USER=wp_dev'
            - 'DB_PASSWORD=pa55word'

  db:
    image: mariadb:latest
    environment:
      - 'MYSQL_RANDOM_ROOT_PASSWORD=yes'
      - 'MYSQL_USER=wp_dev'
      - 'MYSQL_PASSWORD=pa55word'
      - 'MYSQL_DATABASE=wp_dev'
```

Now you can simply run:

```
docker-compose up
```

Wordpress will now be running and you can visit `http://localhost:8080` in your browser.