import pymysql as mysql

from export_to_mysql.db_secrets import *

if ENGINE == 'MySQL':
    VARCHAR_LIMIT = 255
else:
    VARCHAR_LIMIT = 500

connection = mysql.connect(host=HOST,
                           password=PASSWORD,
                           port=PORT,
                           user=USER,
                           db=DB)

def write_noc_codes(noc_uniques):
    sql = 'INSERT INTO noc_uniques ' \
            '(noc_code, base_description_en, base_description_fr)' \
            'VALUES (%s, %s, %s)'
    with connection.cursor() as cursor:
        for noc_code in noc_uniques:
            cursor.execute(sql, (noc_code['noc_code'],
                                 noc_code['base_description_en'][:VARCHAR_LIMIT],
                                 noc_code['base_description_fr'][:VARCHAR_LIMIT]))
    connection.commit()
