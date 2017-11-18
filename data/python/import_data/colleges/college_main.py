"""
Process and upload to database
"""

import csv
import os
import pymysql as mysql

from pprint import pprint  # Used for testing -> printing results prettily - can remove

from data_manipulation_basics import *
from export_to_mysql.db_secrets import *


if ENGINE == 'MySQL':
    VARCHAR_LIMIT = 255
    LONG_VARCHAR = 254
else:
    VARCHAR_LIMIT = 750
    LONG_VARCHAR = 3000

COLLEGE_LIST_FILE = 'additional/Institution Information.csv'
COLLEGE_PROGRAMS = 'Student-Pathways-Challenge-All-Data-v2-utf8/2 - Graduation/7-College-Graduation-Rate-utf8/college_programs.txt'

connection = mysql.connect(host=HOST,
                           password=PASSWORD,
                           port=PORT,
                           user=USER,
                           db=DB)

def process_college_univ_list(file_name=COLLEGE_LIST_FILE, encoding='utf-8'):
    sql = 'INSERT INTO institutions ' \
            '(institution_type, institution_code, institution_name, ' \
            'postal_code, city, url) ' \
            'VALUES (%s, %s, %s, %s, %s, %s)'
    file_path = os.path.join(BASE_PATH, file_name)
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f)
        for line in reader:
            if line['Institution Type'].replace('\xa0', ' ') == 'College':
                line['Institution Type'] = 'C'
            else:
                line['Institution Type'] = 'U'
            line['City'] = line['City and Province'][:line['City and Province'].index('ON')].replace('\xa0', ' ')

            with connection.cursor() as cursor:
                cursor.execute(sql, (line['Institution Type'],
                                     line['Institution Code'],
                                     line['Institution Name'].replace('\xa0', ' '),
                                     line['Postal Code'].replace('\xa0', ' '),
                                     line['City'],
                                     line['Website']))
    connection.commit()


def process_college_program_list(file_name=COLLEGE_PROGRAMS, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    with open(file_path, encoding=encoding) as f:

        pprint(list(f))
