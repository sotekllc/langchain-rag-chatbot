# Hospital Visits ChatBot using LangChain

This repo is the code and data for an AI Agent built using LangChain that answers questions about hospital visits. This includes questions around physicians, visits, insurance payers, patient reviews and hospitals.

## Getting Started

Git clone the repo down to your machine.

Create the following folders from the root directory, otherwise neo4j will fail to start with permissions issues:

- ./neo4j
- ./neo4j/logs
- ./neo4j/config
- ./neo4j/data
- ./neo4j/plugin

```
You'll also need to adjust the permissions of these folders so the neo4j instance can write to them and add subfolders. You can either make them world writable:
    sudo chmod -R 777 ./neo4j/
or you can change the ownership to the user that the neo4j process runs as, which is 7474 (you can see them set this up in the Dockerfile for the neo4j image):
    sudo chown -R 7474:7474 ./neo4j/
```

Create in the root directory a file called `neo4j_auth.txt` and add a new password to it; this is the password for connecting over basic auth to the neo4j instance, and will be set when the container first starts up:

```
neo4j/NEW_PASSWORD_HERE
```

Update and set the values in the `.env` file following the `.env.example` file for guidance.


## High-Level Process for Building

### Identify an open source dataset

Using the [Healthcare Dataset by Prasad Patil](https://www.kaggle.com/datasets/prasad22/healthcare-dataset?resource=download), we use the star schema design to create schemas for how this data may be stored in a relational database and generate data to fill in missing areas from the original dataset. This yields the following "tables":

* hospitals
* payers
* physicians
* reviews
* visits        (this table ties together multiple other tables)

### Sytem Design at a High-Level

![system diagram](images/rag_system_diagram.png)

We're using an OpenAI GPT LLM as the AI agent LLM, and LangChain to orchestrate how that agent responds to queries. Depending on the question or query to the agent, it decides whch chain or function to use to answer the question. In some cases, it retrieves graph or vectorized data to provide as context for answering the question (this is known as Retrieval Augmented Generation, or RAG).

When the agent is asked about reviews or what patients have said about their visits, it retrieves vectorized reviews related to the question embedding and provides a sample of them as context to answer the question. When the agent is asked about patients, physicians, visits, insurance payments, etc, it will run a cipher query against the neo4j knowledge graph database and provide the query result as context for answering the question.

One challenge among the design is answering subjective versus objective questions such as "How much money did BlueCross pay to hospitals in 2023?" versus "What did patients have to say about how staff communicated with them?" - one should query a database of data from the tables, and the other should query the patient reviews for relevant information.

This results in two different chains for agentic responses such that TODO_COMPLETE_HERE


### Knowledge Graph Database

To allow querying the CSV data and vectorized reviews from our agent, we create a knowledge graph of the data and then run an ETL job to load the CSV data into a neo4j graph database according to the following knowledge graph:

![CSV data knowledge graph](images/hospital_data_graph.png)

The job handles loading the nodes and edges (relationships) into the neo4j instance, and we can access this knowledge graph data by running cipher queries against the neo4j instance (cipher is the query language of neo4j).


