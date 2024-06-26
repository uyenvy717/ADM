# Data warehouse and dashboard exam assignment template
This is a template project for the exam assignment, based on a *Devcontainer*. It has been tested with Visual Studio Code. The data files for the assignment can be found in a separate zip file on Blackboard.

## Structure
This project consists of an empty dbt project. Additionally you'll find the following folders:
- **api**: contains the API with driver and team information. See `README.md` in that folder for more information.
- **load**: should contain your load script and the data to load into a DuckDB database.
- **reports:** contains an empty Evidence.dev project.

## Installation
1. Follow the instructions at https://code.visualstudio.com/docs/devcontainers/tutorial (stop before 'Get the sample')
2. Open the folder that contains this README file in Visual Studio Code.
3. Click on 'Reopen in Container' in the popup at the bottom right of the window.
4. Wait until the container has started up and has finished installing everything.

## Running the application
### Loading data with Python
Start your loading scripts with `python load/load_data.py`

### Running DBT
You can execute the dbt commands by running: `dbt run` in the current folder.

### Running DuckDB
You can run DuckDB using: `duckdb <database_filename>`
#   A D M  
 