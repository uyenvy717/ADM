import os
import pandas as pd
import requests
import duckdb

# Load data from a CSV file into duckdb.
def load_data_from_csv(conn, file_path):
    print('csv')
    df = pd.read_csv(file_path)
    # Preprocess the data frame
    table_name = os.path.basename(file_path).replace(".csv", "")
    
    # Determine the category based on the table name
    category = determine_category(table_name)

    # Ensure the formula1 schema exists
    conn.execute("CREATE SCHEMA IF NOT EXISTS formula1")
    
    # Use DuckDB's from_df method, but also specify the schema "formula1"
    if category == "other":
        conn.from_df(df).create(f"formula1.{table_name}")
    else:
        table_name = f"formula1.{category}"
        try:
            # Check if the table already exists in the catalog
            result = conn.execute(f"SELECT * FROM {table_name} LIMIT 1")
        except duckdb.CatalogException:
            # Table doesn't exist, create it
            print("trying to create table data")
            conn.from_df(df).create(table_name)
        else:
            # Table exists, append data
            print("trying to append data")
            # Loop through each row in the DataFrame and insert it into the table
            for index, row in df.iterrows():
                values = ", ".join(f"'{value}'" for value in row.values)
                sql_query = f"INSERT INTO {table_name} VALUES ({values})"
                conn.execute(sql_query)

# Load data from a TXT file into duckdb.
def load_data_from_text(conn, file_path):
    print('txt')
    with open(file_path, 'r') as file:
        lines = file.readlines()

    table_name = os.path.basename(file_path).replace(".txt", "")

    # Determine the category based on the table name
    category = determine_category(table_name)

    # Remove extra spaces from the beginning or end of lines then make a list.
    data = [{'line_content': line.strip(), 'category': category} for line in lines]

    df = pd.DataFrame(data)

    # Ensure the formula1 schema exists
    conn.execute("CREATE SCHEMA IF NOT EXISTS formula1")

    # Use DuckDB's from_df method, but also specify the schema "formula1"
    if category == "other":
        conn.from_df(df).create(f"formula1.{table_name}")
    else:
        table_name = f"formula1.{category}"
        try:
            # Check if the table already exists in the catalog
            result = conn.execute(f"SELECT * FROM {table_name} LIMIT 1")
        except duckdb.CatalogException:
            # Table doesn't exist, create it
            print("trying to create table data")
            conn.from_df(df).create(table_name)
        else:
            # Table exists, append data
            print("trying to append data")
            # Loop through each row in the DataFrame and insert it into the table
            for index, row in df.iterrows():
                values = ", ".join(f"'{value}'" for value in row.values)
                sql_query = f"INSERT INTO {table_name} VALUES ({values})"
                conn.execute(sql_query)

# Determine the category based on the table name
def determine_category(table_name):
    # Define naming patterns and corresponding categories
    patterns_to_categories = {
        "_laps": "laps",
        "_racecontrol": "racecontrol",
        "_weather": "weather",
        "_car_data": "car_data",
        "_car_positions": "car_positions"
        # Add more patterns and categories as needed
    }
    
    for pattern, category in patterns_to_categories.items():
        if pattern in table_name:
            return category

    # If no pattern matches, return a default category
    return "other"

# Fetch data from given API endpoint.
def fetch_data_from_api(api_endpoint):
    print('check api')
    response = requests.get(api_endpoint)
    if response.status_code == 200:
        data = response.json()
        return data
    else:
        print(f"Failed to fetch data from {api_endpoint}")
        return None
    
# Load driver details data from the API
def load_driver_details(conn, api_base_url, drivers_data):
    print('drivers')
    data = []
    for driver in drivers_data:
        driver_details_endpoint = f"{api_base_url}/drivers/{driver}"
        driver_details = fetch_data_from_api(driver_details_endpoint)
        if driver_details:
            data.append(driver_details)
    drivers_df = pd.DataFrame(data)
    conn.from_df(drivers_df).create("formula1.drivers") 

# Load team details data from the API
def load_team_details(conn, api_base_url, teams_data):
    print('teams')
    data = []
    for team in teams_data:
        team_details_endpoint = f"{api_base_url}/teams/{team}"
        team_details = fetch_data_from_api(team_details_endpoint)
        if team_details:
            data.append(team_details)
    teams_df = pd.DataFrame(data)
    conn.from_df(teams_df).create("formula1.teams")

# Load data from different sources (CSV files, TXT files, API) into duckdb.
def load_data_into_duckdb(conn, data_directory, api_base_url):  
    print('loading')
    data_files = os.listdir(data_directory)
    for file in data_files:
        file_path = os.path.join(data_directory, file)

        # Handle file format
        if file.endswith(".csv"):
            load_data_from_csv(conn, file_path)
        elif file.endswith(".txt"):
            load_data_from_text(conn, file_path)

     # Handle api endpoint for drivers
    drivers_api_endpoint = f"{api_base_url}/drivers"
    drivers_data = fetch_data_from_api(drivers_api_endpoint)
    if drivers_data:
        load_driver_details(conn, api_base_url, drivers_data)

    # Handle api endpoint for teams
    teams_api_endpoint = f"{api_base_url}/teams"
    teams_data = fetch_data_from_api(teams_api_endpoint)
    if teams_data:
        load_team_details(conn, api_base_url, teams_data)


def main():
    # Get the absolute path of the current script
    script_directory = os.path.dirname(os.path.abspath(__file__))
    print('script', script_directory)

    # Set the data_directory relative to the script location
    project_directory = os.path.dirname(script_directory)  # Go up one levels to the root
    data_directory = os.path.join(project_directory, "assignment2-data", "output")
    print('project', project_directory)
    print('data', data_directory)
    api_base_url = "http://localhost:3000"

    # Set db_path relative to the script location
    # db_directory = os.path.join(project_directory, "retake-assignment2-olap", "dbt_formula1")
    db_directory = os.path.dirname(script_directory)
    db_path = os.path.join(db_directory, "database.duckdb")

    # Print the constructed db_path for debugging
    conn = duckdb.connect(database=db_path)
    load_data_into_duckdb(conn, data_directory, api_base_url)

if __name__ == "__main__":
    main()
