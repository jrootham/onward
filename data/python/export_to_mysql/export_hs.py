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

def write_hs_courses(input_list):
    sql = 'INSERT INTO hs_courses ' \
            '(course_code, course_name_en, course_name_fr, has_prereq) ' \
            'VALUES (%s, %s, %s, %s)'
    with connection.cursor() as cursor:
        for item in input_list:
            cursor.execute(sql, (item['course_code'],
                                 item['course_name_en'],
                                 item['course_name_fr'],
                                 item['has_prereq']))
    connection.commit()

def write_hs_grade_map(input_list):
    sql = 'INSERT INTO hs_course_grade_link ' \
            '(course_code, grade) ' \
            'VALUES (%s, %s)'
    with connection.cursor() as cursor:
        for item in input_list:
            try:
                cursor.execute(sql, (item['course_code'],
                                     item['grade']))
            except mysql.err.IntegrityError:
                pass
    connection.commit()


def write_hs_course_prereqs(input_list):
    sql = 'INSERT INTO hs_course_prereq ' \
            '(course_code, prereq_code) ' \
            'VALUES (%s, %s)'
    with connection.cursor() as cursor:
        for item in input_list:
            try:
                cursor.execute(sql, (item['course_code'],
                                     item['prereq_code']))
            except mysql.err.IntegrityError:
                print('ERROR')
                print(item)
    connection.commit()
