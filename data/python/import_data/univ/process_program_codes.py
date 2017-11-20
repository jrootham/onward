import os
import csv
import re
import pymysql as mysql

from export_to_mysql.db_secrets import *
from data_manipulation_basics import *

from pprint import pprint

if ENGINE == 'MySQL':
    VARCHAR_LIMIT = 255
    LONG_VARCHAR = 254
else:
    VARCHAR_LIMIT = 750
    LONG_VARCHAR = 3000

regex = r'\|\s[A-Z]{2,3}\s\|'

connection = mysql.connect(host=HOST,
                           password=PASSWORD,
                           port=PORT,
                           user=USER,
                           db=DB,
                           charset='utf8')

OUAC_TOP = 'additional/ouac_top_level.txt'
OUAC_CATS = 'additional/ouac_categories.txt'
OUAC_PROGRAMS = 'Student-Pathways-Challenge-All-Data-v2-utf8/4 - Admission/14-University-Prerequisites-utf8/unv_programs.txt'
OUAC_MAESD_MAP = 'additional/ouac_maesd.txt'
CIP_MAESD_MAP = 'additional/cip_maesd.txt'

def load_codes_from_file(file_id, encoding='utf-8'):
    list_of_codes = set()
    file_path = os.path.join(BASE_PATH, 'additional/univ_program_codes', str(file_id) + '.txt')
    with open(file_path, encoding=encoding) as f:
        for line in f:
            code_match = re.search(
                regex, line
            )
            if code_match:
                match_str = code_match.group(0)
                list_of_codes.add(match_str[2:len(match_str)-2])
    return list_of_codes


def process_ouac_top():
    top_file_path = os.path.join(BASE_PATH, OUAC_TOP)
    top_sql = 'INSERT INTO ouac_top_category ' \
            '(ouac_top_code, description_en, description_fr) ' \
            'VALUES (%s, %s, %s)'
    with open(top_file_path, encoding='utf-8') as f:
        reader = csv.DictReader(f, delimiter='|')
        for line in reader:
            with connection.cursor() as cursor:
                cursor.execute(top_sql, (line['ouac_top_code'],
                                         line['description_en'],
                                         line['description_en']))
    connection.commit()


def process_ouac_subs():
    top_file_path = os.path.join(BASE_PATH, OUAC_TOP)
    top_sql = 'INSERT INTO ouac_top_category ' \
            '(ouac_top_code, description_en, description_fr) ' \
            'VALUES (%s, %s, %s)'
    with open(top_file_path, encoding='utf-8') as f:
        reader = csv.DictReader(f, delimiter='|')
        for line in reader:
            with connection.cursor() as cursor:
                cursor.execute(top_sql, (line['ouac_top_code'],
                                         line['description_en'],
                                         line['description_en']))
    connection.commit()


def process_ouac_subs():
    cat_sql = 'INSERT INTO ouac_sub_categories ' \
            '(ouac_cat_code, ouac_top_code, description_en, description_fr) ' \
            'VALUES (%s, %s, %s, %s)'
    cat_file_path = os.path.join(BASE_PATH, OUAC_CATS)
    with open(cat_file_path, encoding='utf-8') as f:
        reader = csv.DictReader(f, delimiter='|')
        for line in reader:
            with connection.cursor() as cursor:
                cursor.execute(cat_sql, (line['ouac_cat_code'],
                                         line['ouac_top_code'],
                                         line['description_en'],
                                         line['description_en']))
    connection.commit()


def process_ouac_programs():
    file_path = os.path.join(BASE_PATH, OUAC_PROGRAMS)
    sql = 'INSERT INTO ouac_programs ' \
            '(ouac_program_code, description_en, description_fr) ' \
            'VALUES (%s, %s, %s)'
    with open(file_path, encoding='utf-8') as f:
        fieldnames = ('program_code', 'description_en')
        reader = csv.DictReader(f, fieldnames=fieldnames, delimiter='\t')
        for line in reader:
            with connection.cursor() as cursor:
                cursor.execute(sql, (line['program_code'],
                                     line['description_en'],
                                     line['description_en']))
    connection.commit()


def process_all_web_pages():
    process_ouac_top()
    process_ouac_subs()
    process_ouac_programs()
    ouac_programs = {}
    sql = 'INSERT INTO ouac_program_cat_map ' \
            '(ouac_program_code, ouac_cat_code) ' \
            'VALUES (%s, %s)'
    file_list_path = os.path.join(BASE_PATH, 'additional/univ_program_codes')
    file_list = os.listdir(file_list_path)
    for file_name in file_list:
        if file_name[-3:] == 'txt':
            ouac_programs[file_name[:-4]] = load_codes_from_file(file_name[:-4])
    for cat_code in ouac_programs:
        for program_code in ouac_programs[cat_code]:
            try:
                with connection.cursor() as cursor:
                    cursor.execute(sql, (program_code, cat_code))
            except mysql.err.IntegrityError as e:
                pass
    connection.commit()

def map_ouac_to_maesd(file_name=OUAC_MAESD_MAP, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    sql = 'INSERT INTO program_ouac_map ' \
            '(program_code, ouac_top_code) ' \
            'VALUES (%s, %s)'
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f, delimiter='|')
        for line in reader:
            with connection.cursor() as cursor:
                cursor.execute(sql, (line['maesd'],
                                     line['ouac_top_code']))
    connection.commit()


def map_cip_to_maesd(file_name=CIP_MAESD_MAP, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    sql = 'INSERT INTO program_cip_map ' \
            '(program_code, cip_top_code) ' \
            'VALUES (%s, %s)'
    with open(file_path, encoding=encoding) as f:
        reader=csv.DictReader(f, delimiter='|')
        for line in reader:
            with connection.cursor() as cursor:
                cursor.execute(sql, (line['maesd_code'],
                                     line['cip_codes']))
    connection.commit()


def process_map_tables():
    map_ouac_to_maesd()
    map_cip_to_maesd()
