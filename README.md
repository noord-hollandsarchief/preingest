# Noord-Hollands Archief Pre-Ingest tooling

A collection of tools for validation and transformation, to support transferring archives to
[the NHA e-Depot](https://noord-hollandsarchief.nl/informatiebeheer/e-depot).

:warning: THIS IS VERY MUCH WORK IN PROGRESS. For details, [contact us](mailto:arjan.van.bentem@noord-hollandsarchief.nl).


## Development

The Docker images expect the folders `/data` and `/data/etc` to be mapped to some folder outside the containers.

:warning: Docker does not support symbolic links (unless they're supposed to map to folders inside the containers).

- Make the location of the incoming archives known in the environment variable `DATAFOLDER`, and point `ETCFOLDER` to
  [`data/etc` in this very project](./data/etc). For example:
  
  - Create a `.env` file in the root of this project, holding lines like:
  
    ```text
    DATAFOLDER=/path/to/data
    ETCFOLDER=/path/to/project/preingest/data/etc
    ```

  - or:
    
    ```text
    export DATAFOLDER=/path/to/data
    export ETCFOLDER=/path/to/projects/preingest/data/etc
    ```

  - or:
    
    ```text
    set DATAFOLDER=D:\path\to\data
    set ETCFOLDER=D:\path\to\projects\preingest\data\etc
    ```

- To run all Docker containers, pulling the development images if needed, run:

  ```text
  docker-compose up
  ```

- To build new images locally, see [docker-compose.dev.yml](docker-compose.dev.yml) and use with:

  ```text
  docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
  ```

  Alternatively, copy that example `docker-compose.dev.yml` into a file `docker-compose.override.yml`, which will be
  used automatically when `docker-compose up` is used.

### OpenAPI (formerly Swagger)

The [OpenAPI specification](/data/etc/swagger/swagger.json) for use in, e.g., Swagger UI or Postman is maintained
manually. When using `docker-compose.yml`, this internal API can be accessed from `localhost:8000`, like
<http://localhost:8000/api/preingest/check> to see the API's health status.


## Troubleshooting

- `clamav exited with code 137` and `/bootstrap.sh: line 35: 15 Killed clamd`: increase the memory for the Docker host
