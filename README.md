# Phoenix Time Manager CMD Section
We are almost there! The following steps are missing:

  $ cd TimeManagerProject

Then configure your database in config/dev.exs and run:

  $ mix ecto.create

Start your Phoenix app with:

  $ mix phx.server

You can also run your app inside IEx (Interactive Elixir) as:

  $ iex -S mix phx.server

# Docker Section

To build the Docker image, run:

  $ docker-compose up --build -d

To start the Docker container, run:
  
    $ docker-compose up

To stop the Docker container, run:

    $ docker-compose down

To access the Docker container, run:

    $ docker exec -it containerName /bin/bash

# Vue Section

To start the Vue app, run:

  $ cd TimeManagerInterface

  $ npm install

  $ npm run serve