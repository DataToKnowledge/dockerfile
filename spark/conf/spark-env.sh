#!/usr/bin/env bash

# This file is sourced when running various Spark programs.
export SPARK_WORKER_CORES=1
export SPARK_WORKER_MEMORY=3G
export SPARK_WORKER_PORT=7078
export SPARK_MASTER_OPTS="-Dspark.worker.timeout=600"
