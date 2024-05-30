FROM mcr.microsoft.com/devcontainers/python:3.12

# pipx install dbt-duckdb --include-deps
RUN pip3 install dbt-duckdb

RUN wget https://github.com/duckdb/duckdb/releases/download/v0.10.2/duckdb_cli-linux-amd64.zip \
    && unzip duckdb_cli-linux-amd64.zip \
    && rm duckdb_cli-linux-amd64.zip \
    && mv duckdb /usr/local/bin/

COPY .duckdbrc /home/vscode/

RUN pip3 install pandas
