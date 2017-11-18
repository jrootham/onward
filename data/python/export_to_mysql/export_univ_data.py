import pymysql as mysql

from pprint import pprint

from export_to_mysql.db_secrets import *

if ENGINE == 'MySQL':
    VARCHAR_LIMIT = 255
    LONG_VARCHAR = 254
else:
    VARCHAR_LIMIT = 750
    LONG_VARCHAR = 3000

connection = mysql.connect(host=HOST,
                           password=PASSWORD,
                           port=PORT,
                           user=USER,
                           db=DB)

def write_cip_top_level(cip_data):
    sql = 'INSERT INTO cip_top_level ' \
            '(cip_top_code, description_en, description_fr) ' \
            'VALUES (%s, %s, %s)'
    with connection.cursor() as cursor:
        for item in cip_data:
            cursor.execute(sql, (item['Code'],
                                 item['Description_en'],
                                 item['Description_en']))
    connection.commit()


def write_univ_programs(univ_programs):
    sql = 'INSERT INTO univ_programs ' \
            '(program_code, description_en, description_fr) ' \
            'VALUES (%s, %s, %s)'
    with connection.cursor() as cursor:
        for program in univ_programs:
            cursor.execute(sql, (program['program_code'],
                                 program['description_en'],
                                 program['description_fr']))
    connection.commit()


def write_univ_noc_employement(input_list):
    sql = 'INSERT INTO univ_noc_employment ' \
            '(employed, noc_code, program_code, self_employed, year) ' \
            'VALUES (%s, %s, %s, %s, %s)'
    with connection.cursor() as cursor:
        for item in input_list:
            cursor.execute(sql, (item['employed'],
                                 item['noc_code'],
                                 item['program_code'],
                                 item['self_employed'],
                                 item['year']))
    connection.commit()


def write_credentials(input_list):
    sql = 'INSERT INTO credentials '\
            '(credential_code, description_en, description_fr) ' \
            'VALUES (%s, %s, %s)'
    with connection.cursor() as cursor:
        for item in input_list:
            cursor.execute(sql, (item['credential_code'],
                                 item['description_en'],
                                 item['description_fr']))
    connection.commit()


def write_univ_programs_specific(input_list):
    sql = 'INSERT INTO cip_codes '\
            '(cip_top_code, cip_program_code, description_en, description_fr) ' \
            'VALUES (%s, %s, %s, %s)'
    with connection.cursor() as cursor:
        for item in input_list:
            cursor.execute(sql, (item['specific_code'][:2],
                                 item['specific_code'],
                                 item['description_en'],
                                 item['description_fr']))
    connection.commit()


def write_noc_specific_program(input_list):
    sql = 'INSERT INTO noc_specific_program ' \
            '(noc_code, credential_code, cip_program_code, job_count) ' \
            'VALUES (%s, %s, %s, %s)'
    with connection.cursor() as cursor:
        for item in input_list:
            cursor.execute(sql, (item['noc_code'],
                                 item['credential_code'],
                                 item['specific_program_code'],
                                 item['job_count']))
    connection.commit()
