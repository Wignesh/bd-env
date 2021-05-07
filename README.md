# Big Data Environment

## Prerequisites

- Docker
- Make

## How to start

1. Clone this repo

```
  git clone https://github.com/Wignesh/bd-env.git
```

2. Open terminal & navigate to this repo where you cloned
3. Create a hadoop network by `make net`
4. Build the image locally by `make build`
5. Start the container by `make run`
6. Wait for the container to completely start
7. Check the status
    1. Spark Master - [http://localhost:8080](http://localhost:8080)
    2. Namenode - [http://localhost:9870](http://localhost:9870/)
    3. DFS File System - [http://localhost:9870/explorer.html#/](http://localhost:9870/explorer.html#/)

### Running Test Job

1. Connect to the container shell by `make exec`
2. Copy the `auth.csv` to `dfs`
    - auth.csv will be the dataset we'll be using to run the test job
    - if you used make to start the container, this repo will be mounted at `/usr/bin/bd/fs`
    - if not use `make run`
    - so anything you put in this directory will be accessed from the container
    - now in the container shell run `sh fs/put.sh`
        - the put.sh will do all the work to create `/data` directory & copy `auth.csv` to dfs
3. now submit the job by
   ```
   spark-submit --name CodaDataJOB --master spark://bdsncluster:7077 --deploy-mode client --class global.coda.jobs.CountDataJob fs/data/CountSparkJob.jar
   ```

## Commands

`make build`

- This will build a hadoop image on your local system

`make build-prod`

- This will build locally and tag to ghcr

`make push`

- Push the prod image to gcr

`make force-build`

- Build image locally without cache

`make run`

- Start the hadoop container if it’s stopped or
- Spin up a new container with volume mounted from `pwd` to `/usr/bin/bd/fa`

`make rm`

- Remove the stopped hadoop container from docker

`make sr`

- Stop & remove the container from your system

`make prune`

- Removes dangling containers

`make exec`

- Connect to hadoop container shell

`make clean`

- Clean the dfs files stored on the host

`make net`

- Creates an hadoop network