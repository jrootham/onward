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

UNIV_PROGRAMS = 'Student-Pathways-Challenge-All-Data-v2-utf8/4 - Admission/14-University-Prerequisites-utf8/unv_programs.txt'

connection = mysql.connect(host=HOST,
                           password=PASSWORD,
                           port=PORT,
                           user=USER,
                           db=DB,
                           charset='utf8')

def load_program_codes(file_name=UNIV_PROGRAMS, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    max_code_length = 0
    max_desc_len = 0
    line_count = 0
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f, fieldnames=('code', 'description_en'),
                                delimiter='\t')
        for line in reader:
            line_count += 1
            # print(line)
            if len(line['code']) > max_code_length:
                max_code_length = len(line['code'])
            if len(line['description_en']) > max_desc_len:
                max_desc_len = len(line['description_en'])
    print('Max Code Length: ', max_code_length)
    print('Max Desc Length: ', max_desc_len)
    print('Line Count: ', line_count)
