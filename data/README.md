# There are 4 folders in this section of the repo:

1) Additional - contains new datasets other than those provided by contest

2) Student-Pathways-Challenge-All-Data-v2-utf8 - contains provided datasets and derivations from them

3) sql - SQL code to set up database structure

4) python - python code to load data from provided & additional files & write to database
- This is designed to be run from command line.  In python directory, call

```shell
python master_data_process.py
```

## Requirements:
- SQL - for either MySQL or MariaDB
- Python - requires Python3.5 or higher;
  dependencies shown in python/requirements.txt

## Workflow

1) setup venv & dependencies

```shell
python3 -m venv /path/to/new/virtual/environment
source /path/to/new/virtual/environment/bin/activate
pip install PyMySQL
```

2) create a db_secrets.py file in python/export_to_mysql

```shell
touch /path_to_data/python/export_to_mysql/db_secrets.py
```

```python
# Contents of db_secrets.py

HOST = '000.000.000.000'
PASSWORD = 'password'
PORT = 3306
USER = 'username'
DB = 'db_name'
```


2) connect to database through shell

3) Source SQL file to setup database

```sql
source /path_to_data/sql/create_database.sql;
```

4)