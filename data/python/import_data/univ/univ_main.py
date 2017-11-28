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
    'OSSD': ['XXXX',],
    'FRA4U': ['XXXX',],
    '4U/M English': ['ENG4U', 'ETS4U', 'EWC4U'],
    'Invitational': ['XXXX',],
    '4U Biology': ['SBI4U',],
    'ICS3U Math': ['ICS3U', 'MHF4U', 'MCV4U', 'MDM4U'],
    '4U/M Physics': ['SPH4U'],
    'SES4U Math': ['SES4U', 'MHF4U', 'MCV4U', 'MDM4U'],
    'PSK4U Math': ['PSE4U', 'MHF4U', 'MCV4U', 'MDM4U'],
    'Portfolio': ['XXXX',],
    'EAE4U': ['XXXX',],
    '4U Science': ['SBI4U', 'SCH4U', 'SES4U', 'SPH4U'],
    '4U Math': ['MHF4U', 'MCV4U', 'MDM4U'],
    '4U/M Arts': ['ATC4M', 'ADA4M', 'ASM4M', 'AMU4M', 'AVI4M'],
    '4U English': ['ENG4U', 'ETS4U', 'EWC4U'],
    'MDM4U Math': ['MDM4U', 'MHF4U', 'MCV4U', 'MDM4U'],
    '4U/M Geography': ['CGW4U', 'CGU4U'],
    '4U Chemistry': ['SCH4U',],
    '4U Math Biology': ['MHF4U', 'MCV4U', 'MDM4U', 'SBI4U'],
    'SNC3M': ['SNC4M', 'SBI3U', 'SBI4U', 'SCH3U', 'SCH4U', 'SES4U', 'SVN3M', 'SPH3U', 'SPH4U'],
    'Other 4U/M': ['XXXX',],
    '3U Math': ['MCR3U', ],
    'PSK4U;': ['PSE4U', ],
    'Audition': ['XXXX',],
    '4U/M Social Science': ['HFA4M', 'HHS4M', 'HHG4M', 'HSB4M', 'HZT4U', 'CIA4U',
                            'CGW4U', 'CGU4U', 'CGR4M', 'CGO4M', 'CHI4U', 'CHY4U',
                            'CLN4U', 'CPW4U'],
    '4U French': ['FEF4U', 'FEF4U', 'FSF4U'],
    'MHF4U Math': ['MHF4U', 'MCV4U', 'MDM4U'],
    'PSK4U': ['PSE4U', ],
    '4M': ['XXXX',],
    '4U Philosophy': ['HZT4U',],
    '3U/4C Math Physics': ['MCR3U', 'MHF4U', 'MCV4U', 'MDM4U', 'MCT4C', 'MAP4C',
                           'SPH3U', 'SPH4U', 'SPH4C'],
    '4U/M Chemistry': ['SCH4U',],
    'ENG4U Math': ['ENG4U', 'MHF4U', 'MCV4U', 'MDM4U'],
    'ISC4U': ['ICS4U', ],
    '3U': ['XXXX',],
    '4M Arts': ['ATC4M', 'ADA4M', 'ASM4M', 'AMU4M', 'AVI4M'],
    'SPH4UMCV4U': ['SPH4U', 'MCV4U'],
    'MCB4U': ['MCV4U',],
    'SBI4U;': ['SBI4U',],
    '4U/M Science': ['SBI4U', 'SCH4U', 'SES4U', 'SPH4U', 'SNC4M'],
    'SBI4U Math': ['SBI4U', 'MHF4U', 'MCV4U', 'MDM4U'],
    'ASM4U': ['ASM4M',],
    '4U Computer Science': ['ICS4U',],
    '4U Classical Studies': ['LVV4U', 'LVLCU', 'LVGCU'],
    'Other 4U': ['XXXX',],
    '4U Math Science': ['SBI4U', 'SCH4U', 'SES4U', 'SPH4U', 'MHF4U', 'MCV4U', 'MDM4U'],
    '4U Physics': ['SPH4U',],
    'ICS4M': ['ICS4U', 'ICS4C'],
    '4U/M Math': ['MHF4U', 'MCV4U', 'MDM4U'],
    '3U/4C Chemistry': ['SCH3U', 'SCH4U', 'SCH4C'],
    '3M': ['XXXX',],
    '3U/4C English': ['ENG3U', 'ENG4U', 'ENG4C', 'ETS4U', 'ETS4U', 'ETS4U'],
    'MFH4U': ['MHF4U',],
    '4U/M Biology': ['SBI4U',],
    '4U International Language': ['LBACU-LYXCU', 'LBADU-LYXDU'],
    'NBE4U': ['XXXX',],
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


def add_institution(prereq_dict, univ_code):
    if univ_code not in prereq_dict:
        prereq_dict[univ_code] = {}


def add_program(prereq_dict, univ_code, program_code):
    if program_code not in prereq_dict[univ_code]:
        prereq_dict[univ_code][program_code] = {}


def add_program_type(prereq_dict, univ_code, program_code, type_code):
    if type_code not in prereq_dict[univ_code][program_code]:
        prereq_dict[univ_code][program_code][type_code] = {}


def add_specialization(prereq_dict, line):
    univ = line['University']
    program = line['Program']
    max_enroll = line['MaxEnrolment'] if line['MaxEnrolment'] not in \
            ('Open', 'Limited', 'Online') else 0
    type_code = line['ProgramType']
    min_gpa = line['MinGradeAvg']
    spec_code = line['Specialization']

    if spec_code not in prereq_dict[univ][program][type_code]:
        prereq_dict[univ][program][type_code][spec_code] = {
            'max_enroll': max_enroll,
            'min_gpa': min_gpa
        }


def add_prereq_group(prereq_dict, line):
    univ = line['University']
    program = line['Program']
    type_code = line['ProgramType']
    spec_code = line['Specialization']
    group_recommended = line['Recommended'] == 'Y'
    prereq_group = str(line['PrerequisiteGroup'])
    num_picks = line['PrerequisitePicks']
    if prereq_group not in prereq_dict[univ][program][type_code][spec_code]:
        prereq_dict[univ][program][type_code][spec_code][prereq_group] = {
            'num_picks': num_picks,
            'recommended': group_recommended,
            'courses': set()
        }


def add_course(prereq_dict, line):
    univ = line['University']
    program = line['Program']
    type_code = line['ProgramType']
    spec_code = line['Specialization']
    group_recommended = line['Recommended'] == 'Y'
    prereq_group = str(line['PrerequisiteGroup'])
    num_picks = line['PrerequisitePicks']
    course_code_key = line['PrerequisiteCodes']
    if course_code_key in PREREQ_CODE_MAP:
        if PREREQ_CODE_MAP[course_code_key]:
            for course_code in PREREQ_CODE_MAP[course_code_key]:
                prereq_dict[univ][program][type_code][spec_code] \
                        [prereq_group]['courses'].add(course_code)
    else:
        prereq_dict[univ][program][type_code][spec_code] \
                [prereq_group]['courses'].add(course_code_key)


def process_prereq_group(prereq_group_dict, univ_code, prog_code, type_code,
                         spec_code, prereq_group):
    sql1 = 'INSERT INTO univ_prereq_group ' \
            '(ouac_univ_code, ouac_program_code, program_type, ' \
            'specialization, prereq_group_num, num_picks_required, '\
            'recommended_group) ' \
            'VALUES (%s, %s, %s, %s, %s, %s, %s)'
    sql2 = 'INSERT INTO univ_prereq_course ' \
            '(ouac_univ_code, ouac_program_code, program_type, ' \
            'specialization, prereq_group_num, hs_course_code) ' \
            'VALUES (%s, %s, %s, %s, %s, %s)'
    with connection.cursor() as cursor:
        cursor.execute(sql1, (univ_code,
                              prog_code,
                              type_code,
                              spec_code,
                              prereq_group,
                              prereq_group_dict['num_picks'],
                              prereq_group_dict['recommended']))
    for course in prereq_group_dict['courses']:
        with connection.cursor() as cursor:
            cursor.execute(sql2, (univ_code,
                                  prog_code,
                                  type_code,
                                  spec_code,
                                  prereq_group,
                                  course))


def process_spec(spec_dict, univ_code, prog_code, type_code, spec_code):
    sql = 'INSERT INTO university_programs_ouac_code ' \
            '(ouac_univ_code, ouac_program_code, program_type, ' \
            'specialization, max_enroll, min_gpa) ' \
            'VALUES (%s, %s, %s, %s, %s, %s)'
    with connection.cursor() as cursor:
        cursor.execute(sql, (univ_code,
                             prog_code,
                             type_code,
                             spec_code,
                             spec_dict['max_enroll'],
                             spec_dict['min_gpa']))
    for prereq_group in spec_dict:
        if prereq_group not in ('max_enroll', 'min_gpa'):
            process_prereq_group(spec_dict[prereq_group], univ_code, prog_code,
                                 type_code, spec_code, prereq_group)


def process_type_code(prog_dict, univ_code, prog_code, type_code):
    for spec_code in prog_dict:
        process_spec(prog_dict[spec_code], univ_code, prog_code, type_code, spec_code)

def process_program(prog_dict, univ_code, prog_code):
    for type_code in prog_dict:
        process_type_code(prog_dict[type_code], univ_code, prog_code, type_code)


def process_university(univ_dict, univ_code):
    for prog_code in univ_dict:
        process_program(univ_dict[prog_code], univ_code, prog_code)


def load_univ_prereqs(file_name=UNIV_PREREQS, encoding='latin-1'):
    file_path = os.path.join(BASE_PATH, file_name)
    max_prog_type = 0
    max_gpa = 0
    max_spec = 0
    univ_prereqs = {}

    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f)
        for line in reader:
            univ = line['University']
            program = line['Program']
            max_enroll = line['MaxEnrolment']
            prog_type = line['ProgramType']
            min_gpa = line['MinGradeAvg']
            spec_code = line['Specialization']
            group_recommended = line['Recommended'] == 'Y'
            prereq_group = line['PrerequisiteGroup']
            num_picks = line['PrerequisitePicks']
            course_code = line['PrerequisiteCodes']

            add_institution(univ_prereqs, univ)
            add_program(univ_prereqs, univ, program)
            add_program_type(univ_prereqs, univ, program, prog_type)
            add_specialization(univ_prereqs, line)
            add_prereq_group(univ_prereqs, line)
            add_course(univ_prereqs, line)

    for univ_code in univ_prereqs:
        process_university(univ_prereqs[univ_code], univ_code)
    connection.commit()
