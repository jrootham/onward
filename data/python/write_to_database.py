import pymysql as mysql
from database_secrets import *
from **SOMEWHERE** import **STUFFTOWRITE**

connection = mysql.connect(host=HOST,
                           password=PASSWORD,
                           port=PORT,
                           user=USER,
                           db=DB)

def write_noc_codes(list_of_noc_uniques):
    sql = 'INSERT INTO noc_noc_uniques (%s)'
    with connection.cursor() as cursor:
        for noc_code in list_of_noc_uniques:
            cursor.execute(sql, [noc_code,])
        connection.commit()
