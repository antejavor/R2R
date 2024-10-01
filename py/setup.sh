#!/bin/bash

# # Start Neo4j
# docker run -d \
#     --rm \
#     --name neo4j \
#     --publish=7474:7474 --publish=7687:7687 \
#     -e NEO4J_AUTH=neo4j/ineedastrongerpassword \
#     -e NEO4J_dbms_memory_pagecache_size=${NEO4J_PAGECACHE_SIZE:-512M} \
#     -e NEO4J_dbms_memory_heap_max__size=${NEO4J_HEAP_SIZE:-512M} \
#     -e NEO4J_apoc_export_file_enabled=true \
#     -e NEO4J_apoc_import_file_enabled=true \
#     -e NEO4J_apoc_import_file_use__neo4j__config=true \
#     -e NEO4JLABS_PLUGINS='["apoc"]' \
#     -e NEO4J_dbms_security_procedures_unrestricted=apoc.* \
#     -e NEO4J_dbms_security_procedures_allowlist=apoc.* \
#     -v neo4j_data:/data \
#     -v neo4j_logs:/logs \
#     -v neo4j_plugins:/plugins \
#     -d neo4j:5.23.0


if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo ".env file not found!"
    exit 1
fi

# Start Memgraph 
docker run -d \
  --rm \
  --name memgraph \
  -p 7687:7687 \
  -e MEMGRAPH_USER=memgraph \
  -e MEMGRAPH_PASSWORD=memgraph \
  -v memgraph_data:/var/lib/memgraph \
  -v memgraph_logs:/var/log/memgraph \
  memgraph/memgraph-mage:1.20-memgraph-2.20-no-ml --log-level=TRACE --also-log-to-stderr


# Start PostgreSQL
docker run -d \
  --rm \
  --name postgres \
    -p 5432:5432 \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=postgres \
  -v postgres_data:/var/lib/postgresql/data \
  pgvector/pgvector:pg16



# export NEO4J_USER=neo4j
# export NEO4J_PASSWORD=ineedastrongerpassword
# export NEO4J_URL=bolt://localhost:7687
# export NEO4J_DATABASE=neo4j

export MEMGRAPH_DATABASE=memgraph
export MEMGRAPH_USER=memgraph
export MEMGRAPH_PASSWORD=memgraph
export MEMGRAPH_URL=bolt://localhost:7687

export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=postgres
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export POSTGRES_DBNAME=postgres
export POSTGRES_VECS_COLLECTION=vecs


export UNSTRUCTURED_API_URL=https://api.unstructured.io/general/v0/general
# ollama start