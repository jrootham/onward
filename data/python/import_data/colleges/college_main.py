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
COLLEGE_CAMPUSES = 'additional/pc_inst.csv'
COLLEGE_PROGRAMS = 'Student-Pathways-Challenge-All-Data-v2-utf8/2 - Graduation/7-College-Graduation-Rate-utf8/college_programs.txt'
COLLEGE_GRAD_RATES = 'Student-Pathways-Challenge-All-Data-v2-utf8/2 - Graduation/7-College-Graduation-Rate-utf8/7-College-Graduation-Rate-utf8.csv'

connection = mysql.connect(host=HOST,
                           password=PASSWORD,
                           port=PORT,
                           user=USER,
                           db=DB,
                           charset='utf8')

def process_college_univ_list(file_name=COLLEGE_LIST_FILE, encoding='utf-8'):
    sql = 'INSERT INTO institutions ' \
            '(institution_type, institution_code, institution_name, url) ' \
            'VALUES (%s, %s, %s, %s)'
    file_path = os.path.join(BASE_PATH, file_name)
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f)
        for line in reader:
            if line['Institution Type'].replace('\xa0', ' ') == 'College':
                line['Institution Type'] = 'C'
            else:
                line['Institution Type'] = 'U'
            with connection.cursor() as cursor:
                cursor.execute(sql, (line['Institution Type'],
                                     line['Institution Code'],
                                     line['Institution Name'].replace('\xa0', ' '),
                                     line['Website']))
    connection.commit()


def process_campus_list(file_name=COLLEGE_CAMPUSES, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    sql = 'INSERT INTO campuses ' \
            '(institution_code, institution_type_code, campus_name, ' \
            'campus_postal_code, main_campus) ' \
            'VALUES (%s, %s, %s, %s, %s)'
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f)
        for line in reader:
            if line['INSTITUTION'] not in ('', None):
                with connection.cursor() as cursor:
                    cursor.execute(sql, (line['INSTITUTION'],
                                         line['INSTITUTION_TYPE_CODE'],
                                         line['INSTITUTION_TYPE_EN_DESC'],
                                         line['POSTAL_CODE'],
                                         line['MAIN']))
    connection.commit()


def process_college_program_list(file_name=COLLEGE_PROGRAMS, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    sql = 'INSERT INTO college_programs ' \
            '(college_program_code, description_en, description_fr) ' \
            'VALUES (%s, %s, %s)'
    with open(file_path, encoding=encoding) as f:
        fieldnames = [h.strip() for h in next(f).split('\t')]
        reader = csv.DictReader(f, fieldnames=fieldnames, delimiter='\t')
        for line in reader:
            with connection.cursor() as cursor:
                cursor.execute(sql, (line['code'].strip(),
                                     line['description_en'].strip(),
                                     line['description_fr'].strip()))
    connection.commit()


def process_college_grad_rates(file_name=COLLEGE_GRAD_RATES, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
