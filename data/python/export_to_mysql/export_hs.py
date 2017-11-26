import pymysql as mysql

from pprint import pprint

from export_to_mysql.db_secrets import *

if ENGINE == 'MySQL':
    VARCHAR_LIMIT = 255
    LONG_VARCHAR = 254
else:
    VARCHAR_LIMIT = 750
    LONG_VARCHAR = 3000


COURSE_AREA = {
    'A': ('The Arts', 'Les arts'),
    'B': ('Business studies', "Études d'affaires"),
    'C': ('Canadian and World Studies', "Études canadiennes et étrangers"),
    'L': ('Languages', 'Langues'),
    'IC': ('Computer Studies', 'Études informatique'),
    'E': ('English', 'Anglais'),
    'F': ('French', 'Français'),
    'G': ('Guidance and Career Education', 'Conseils et education de carrière'),
    'P': ('Health and Physical Education', 'Santé et education physique'),
    'ID': ('Interdisciplinary Studies', 'Études interdisciplinaires'),
    'M': ('Mathematics', 'Mathématiques'),
    'N': ('Native studies', 'Études autochtones'),
    'S': ('Science', 'Sciences'),
    'H': ('Social Sciences and Humanities', 'Humanités et sciences sociaux'),
    'T': ('Technological Education', 'Éducation technique')
}


connection = mysql.connect(host=HOST,
                           password=PASSWORD,
                           port=PORT,
                           user=USER,
                           db=DB)

def write_hs_course_areas():
    sql = 'INSERT INTO hs_course_area ' \
            '(course_area_code, description_en, description_fr) ' \
            'VALUES (%s, %s, %s)'
    for area_code in COURSE_AREA:
        with connection.cursor() as cursor:
            cursor.execute(sql, (area_code,
                                 COURSE_AREA[area_code][0],
                                 COURSE_AREA[area_code][1]))
    connection.commit()


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
    # add 'XXXX' = Other code for university prereqs
    with connection.cursor() as cursor:
        cursor.execute(sql, ('XXXX', 'Other', 'Autre', False))
    connection.commit()
    write_hs_course_areas()

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
