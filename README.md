Development environment in binder, for the course
"Aprendizaje Automatico para Cientificos"

Press this link to open an online dev environment (**WARNING**: all files will be lost if you
close the tab, download them before closing the connection)

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/iluvatar1/ML4Sci-2024/HEAD)

Extra info:

- To build the image, run
  ```bash
  docker build -t ml4sci:0.1 .
  ```
  or
  ```bash
  docker-compose build
  ```
- To run in the backgound
  ```bash
  docker run -dt --name ml4sci -e DOCKER_MACHINE_NAME=ml4sci ml4sci:0.1
  ```
  or
  ```bash
  docker-compose up -d
  ```
- Then attach as
  ```bash
  docker exec -it ml4sci  
  ```
- To test locally:
  ```bash
  docker run -it --rm -p 8888:8888 ml4sci jupyter-lab --NotebookApp.default_url=/lab/ --ip=0.0.0.0 --port=8888
  ```



