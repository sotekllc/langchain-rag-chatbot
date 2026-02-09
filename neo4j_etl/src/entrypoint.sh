#!/bin/bash

# Run any setup steps or pre-processing tasks here
echo "Running ETL to move CSV data to Neo4j..."

# Run the ETL script
poetry run python bulk_csv_write.py