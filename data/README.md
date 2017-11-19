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
### SETUP (First time)

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
# Replace with appropriate values
HOST = '000.000.000.000'
PASSWORD = 'password'
PORT = 3306
USER = 'username'
DB = 'db_name'
# select appropriate value based on db engine
ENGINE = 'MySQL'
# ENGINE = 'MariaDB'  
```

## How to run updates

1) connect to database through shell

```shell
# Replace values as appropriate

# to connect to localhost
mysql -u username -p

# to connect to remote host
mysql -u username -p -h 123.123.123.123
```

2) Delete existing database and create new tables

```sql
-- if localhost
DROP DATABASE IF EXISTS rootham;

-- if on server
-- you'll have to manually go through and drop each table
SHOW TABLES;
SET FOREIGN_KEY_CHECKS = 0;
-- drop each table
SET FOREIGN_KEY_CHECKS = 1;

-- in either case
SOURCE /path/to/onward/data/sql/create_database.sql;
```

3) run python setup from shell

```shell
cd /path/to/with/virtualenv
source env/bin/activate
cd /path/to/onward/data/python
python master_data_process.py
```
