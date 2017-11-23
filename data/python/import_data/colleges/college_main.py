"""
Process and upload to database
"""

import csv
import os
import pymysql as mysql

from pprint import pprint  # Used for testing -> printing results prettily - can remove

from data_manipulation_basics import *
from export_to_mysql.db_secrets import *

UNIV_CODES = {
    'ALGM': ['ALG',],
    'BRCK': ['BRO',],
    'CARL': ['CAR',],
    'GUEL': {'N1G2W1': 'GUE',
             'K0G1J0': 'GUE',
             'N0P2C0': 'GUE',
             'M9W5L7': 'GHU'},
    'HRST': ['UDH',],
    'LAKE': {'L3V7X5': 'LTB',
             'P7B5E1': 'LTB',
             'L3V0B9': 'LOR'},
    'LAUR': ['LAU',],
    'MAC': ['MCM',],
    'NIPS': ['NIP',],
    'NOSM': ['LTB',],
    'OCAD': ['OCA',],
    'OTTW': {'K1N6N5': 'OTT',
             'K1S1C4': 'OSP'},
    'QUEN': ['QUE',],
    'RYER': ['RYE',],
    'TRNT': {'L1J5Y1': 'TDG',
             'K9J7B8': 'TRE'},
    'UOFT': {'M5S1A1': 'TSG',
             'L5L1C6': 'TMI',
             'M1C1A4': 'TSC'},
    'UOIT': ['OIT',],
    'WATR': ['WAT',],
    'WEST': {'N6A3K7': 'WES',
             'N6G1H2': 'WBC',
             'N6G1H3': 'WHC',
             'N6A2M3': 'WKC'},
    'WIND': ['WIN',],
    'WLU': {'N3T2Y3': 'WLB',
            'N2H3W8': 'WLW',
            'M5X1C9': 'WLW',
            'N2L3C5': 'WLW'},
    'YORK': {'M3J1P3': 'YOR',
             'M4N3M6': 'YGC'},
}

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
OUAC_UNIVERSITY = 'Student-Pathways-Challenge-All-Data-v2-utf8/4 - Admission/14-University-Prerequisites-utf8/universities.txt'

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


def get_univ_code(line):
    inst_code = line['INSTITUTION']
    post_code = line['POSTAL_CODE']
    if inst_code in UNIV_CODES:
        short_codes = UNIV_CODES[inst_code]
        if len(short_codes) == 1:
            return short_codes[0]
        if post_code in short_codes:
            return short_codes[post_code]


def process_ouac_university_list(file_name=OUAC_UNIVERSITY, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    fieldnames = ('ouac_code', 'university_desc')
    sql = 'INSERT INTO ouac_univ_codes ' \
            '(ouac_univ_code, ouac_univ_description_en, ouac_univ_description_fr) ' \
            'VALUES (%s, %s, %s)'
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f, fieldnames=fieldnames, delimiter='\t')
        for line in reader:
            with connection.cursor() as cursor:
                cursor.execute(sql, (line['ouac_code'],
                                     line['university_desc'],
                                     line['university_desc']))
    connection.commit()


def process_campus_list(file_name=COLLEGE_CAMPUSES, encoding='utf-8'):
    # Need OUAC list first for foreign key constraint

    file_path = os.path.join(BASE_PATH, file_name)
    sql = 'INSERT INTO campuses ' \
            '(institution_code, institution_type_code, campus_name, ' \
            'campus_postal_code, main_campus, ouac_univ_code) ' \
            'VALUES (%s, %s, %s, %s, %s, %s)'
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f)
        for line in reader:
            if line['INSTITUTION'] not in ('', None):
                with connection.cursor() as cursor:
                    cursor.execute(sql, (line['INSTITUTION'],
                                         line['INSTITUTION_TYPE_CODE'],
                                         line['INSTITUTION_TYPE_EN_DESC'],
                                         line['POSTAL_CODE'],
                                         line['MAIN'],
                                         get_univ_code(line)))
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
    sql = 'INSERT INTO college_grad_rates ' \
            '(institution_code, college_program_code, grad_rate) ' \
            'VALUES (%s, %s, %s)'
    # TODO: COMPLETE THIS IF HAVE TIME
