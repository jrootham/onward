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

UNIV_PREREQS = 'Student-Pathways-Challenge-All-Data-v2-utf8/4 - Admission/14-University-Prerequisites-utf8/14-University-Prerequisites-utf8.csv'

PREREQ_CODE_MAP = {
    'OSSD': [None,],
    'FRA4U': [None,],
    '4U/M English': ['ENG4U', 'ETS4U', 'EWC4U'],
    'Invitational': [None,],
    '4U Biology': ['SBI4U',],
    'ICS3U Math': ['ICS3U', 'MHF4U', 'MCV4U', 'MDM4U'],
    '4U/M Physics': ['SPH4U'],
    'SES4U Math': ['SES4U', 'MHF4U', 'MCV4U', 'MDM4U'],
    'PSK4U Math': ['PSK4U', 'MHF4U', 'MCV4U', 'MDM4U'],
    'Portfolio': [None,],
    'EAE4U': [None,],
    '4U Science': ['SBI4U', 'SCH4U', 'SES4U', 'SPH4U'],
    '4U Math': ['MHF4U', 'MCV4U', 'MDM4U'],
    '4U/M Arts': ['ATC4M', 'ADA4M', 'ASM4M', 'AMU4M', 'AVI4M'],
    '4U English': ['ENG4U', 'ETS4U', 'EWC4U'],
    'MDM4U Math': ['MDM4U', 'MHF4U', 'MCV4U', 'MDM4U'],
    '4U/M Geography': ['CGW4U', 'CGU4U'],
    '4U Chemistry': ['SCH4U',],
    '4U Math Biology': ['MHF4U', 'MCV4U', 'MDM4U', 'SBI4U'],
    'SNC3M': ['SNC4M', 'SBI3U', 'SBI4U', 'SCH3U', 'SCH4U', 'SES4U', 'SVN3M', 'SPH3U', 'SPH4U'],
    'Other 4U/M': [None,],
    '3U Math': ['MCR3U', ],
    'PSK4U;': ['PSE4U', ],
    'Audition': [None,],
    '4U/M Social Science': ['HFA4M', 'HHS4M', 'HHG4M', 'HSB4M', 'HZT4U', 'CIA4U',
                            'CGW4U', 'CGU4U', 'CGR4M', 'CGO4M', 'CHI4U', 'CHY4U',
                            'CLN4U', 'CPW4U'],
    '4U French': ['FEF4U', 'FEF4U', 'FSF4U'],
    'MHF4U Math': ['MHF4U', 'MCV4U', 'MDM4U'],
    'PSK4U': ['PSE4U', ],
    '4M': [None,],
    '4U Philosophy': ['HZT4U',],
    '3U/4C Math Physics': ['MCR3U', 'MHF4U', 'MCV4U', 'MDM4U', 'MCT4C', 'MAP4C',
                           'SPH3U', 'SPH4U', 'SPH4C'],
    '4U/M Chemistry': ['SCH4U',],
    'ENG4U Math': ['ENG4U', 'MHF4U', 'MCV4U', 'MDM4U'],
    'ISC4U': ['ICS4U', ],
    '3U': [None, ],
    '4M Arts': ['ATC4M', 'ADA4M', 'ASM4M', 'AMU4M', 'AVI4M'],
    'SPH4UMCV4U': ['SPH4U', 'MCV4U'],
    'MCB4U': ['MCV4U',],
    'SBI4U;': ['SBI4U',],
    '4U/M Science': ['SBI4U', 'SCH4U', 'SES4U', 'SPH4U', 'SNC4M'],
    'SBI4U Math': ['SBI4U', 'MHF4U', 'MCV4U', 'MDM4U'],
    'ASM4U': ['ASM4M',],
    '4U Computer Science': ['ICS4U',],
    '4U Classical Studies': ['LVV4U', 'LVLCU', 'LVGCU'],
    'Other 4U': [None,],
    '4U Math Science': ['SBI4U', 'SCH4U', 'SES4U', 'SPH4U', 'MHF4U', 'MCV4U', 'MDM4U'],
    '4U Physics': ['SPH4U',],
    'ICS4M': ['ICS4U', 'ICS4C'],
    '4U/M Math': ['MHF4U', 'MCV4U', 'MDM4U'],
    '3U/4C Chemistry': ['SCH3U', 'SCH4U', 'SCH4C'],
    '3M': [None,],
    '3U/4C English': ['ENG3U', 'ENG4U', 'ENG4C', 'ETS4U', 'ETS4U', 'ETS4U', 'EWC4C'],
    'MFH4U': ['MHF4U',],
    '4U/M Biology': ['SBI4U',],
    '4U International Language': ['LBACU–LYXCU', 'LBADU–LYXDU'],
    'NBE4U': [None,],
    '4U Advanced Functions': ['MHF4U',],
    'SCH4U Math': ['SCH4U', 'MHF4U', 'MCV4U', 'MDM4U'],
    '4U History': ['CHI4U', 'CHY4U'],
    'MCV4U Math': ['MCV4U', 'MHF4U', 'MDM4U']
}


connection = mysql.connect(host=HOST,
                           password=PASSWORD,
                           port=PORT,
                           user=USER,
                           db=DB,
                           charset='utf8')

def load_univ_prereqs(file_name=UNIV_PREREQS, encoding='latin-1'):
    file_path = os.path.join(BASE_PATH, file_name)
    prereq_codes = set()
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f)
        for line in reader:
            prereq_codes.add(line['PrerequisiteCodes'])

    unmatched_codes = []
    sql = 'SELECT COUNT(*) FROM hs_courses WHERE course_code = %s'
    for code in prereq_codes:
        with connection.cursor() as cursor:
            cursor.execute(sql, code)
            result = cursor.fetchall()[0][0]
            if not result:
                unmatched_codes.append(code)
    pprint(unmatched_codes)






# def load_ouac_codes(file_name=UNIV_PROGRAMS, encoding='utf-8'):
#     """
#     NOT NEEDED - done in process_program_codes
#     """
#     file_path = os.path.join(BASE_PATH, file_name)
#     max_code_length = 0
#     max_desc_len = 0
#     line_count = 0
#     with open(file_path, encoding=encoding) as f:
#         reader = csv.DictReader(f, fieldnames=('code', 'description_en'),
#                                 delimiter='\t')
#         for line in reader:
#             line_count += 1
#             # print(line)
#             if len(line['code']) > max_code_length:
#                 max_code_length = len(line['code'])
#             if len(line['description_en']) > max_desc_len:
#                 max_desc_len = len(line['description_en'])
#     print('Max Code Length: ', max_code_length)
#     print('Max Desc Length: ', max_desc_len)
#     print('Line Count: ', line_count)
