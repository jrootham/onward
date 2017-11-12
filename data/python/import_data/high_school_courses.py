import csv
import os

from pprint import pprint  # for testing

from data_manipulation_basics import *

COURSE_FILE = 'Student-Pathways-Challenge-All-Data-v2-utf8/4 - Admission/12-High-School-Prerequisites-utf8.csv'
GRADE_DICT = {'9': (9,), '10': (10,), '11': (11,), '12': (12,),
              '9,10': (9, 10), '11,12': (11, 12),
              'Level 1': (9, 10, 11, 12), 'Level 2': (9, 10, 11, 12),
              'Level 3': (9, 10, 11, 12), 'Level 4': (9, 10, 11, 12),
              'Level 5': (9, 10, 11, 12),}
PREREQ_DICT = {'Any Canada/World Studies 4U/C': ('CIE3M',
                                                 'CGF3M',
                                                 'CGD3M',
                                                 'CHA3U',
                                                 'CHW3M',
                                                 'CLU3M',
                                                 'CIA4U',
                                                 'CGW4U',
                                                 'CGR4M',
                                                 'CGO4M',
                                                 'CGU4C',
                                                 'CHI4U',
                                                 'CHY4U',
                                                 'CHY4C',
                                                 'CLN4U',
                                                 'CPW4U'),
               'Any English 4U/C': ('ENG3C',
                                    'ENG3U',
                                    'ETC3M',
                                    'ENG4U',
                                    'ENG4C',
                                    'ETS4U',
                                    'EWC4U'),
               'Any Social Sciences/Humanities 4U/C': ('HPW3C',
                                                       'HIR3C',
                                                       'HSP3M',
                                                       'HFA4M',
                                                       'HHS4M',
                                                       'HHG4M',
                                                       'HSB4M',
                                                       'HZT4U',
                                                       'HRT3M',),
               'Any English (600h)': None,
               'Any English (126h)': None,
               'Any English (380h)': None,
               'Prin. Recommendation': None,
               'Any Science 3U/C': ('SBI3U',
                                    'SBI3C',
                                    'SCH3U',
                                    'SVN3M',
                                    'SPH3U'),
               'Any Health/PhysEd 3/4U/C': ('PPL3O',
                                            'PPZ3O',
                                            'PPL4O'),
               'Any U/C Prep': None,
               'OSSLT': None}


def process_hs_course_tree(file_name=COURSE_FILE, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    course_list = []
    course_codes = set()
    course_grade_map = []
    course_prereq_list = []
    with open(file_path, encoding=encoding) as f:
        reader=csv.DictReader(f)
        for line in reader:
            if line['CourseCode'] not in course_codes:
                course_list.append({
                    'course_code': line['CourseCode'],
                    'course_name_en': line['Course'],
                    'course_name_fr': 'nom du cours non disponible',
                    'has_prereq': line['Prerequisite'] not in ('', None)
                })
                course_codes.add(line['CourseCode'])
            for grade in GRADE_DICT[line['Grade']]:
                course_grade_map.append({
                    'course_code': line['CourseCode'],
                    'grade': grade
                })
            if line['Prerequisite'] not in ('', None):
                if line['Prerequisite'] in PREREQ_DICT:
                    if PREREQ_DICT[line['Prerequisite']] is not None:
                        for prereq_code in PREREQ_DICT[line['Prerequisite']]:
                            if prereq_code != line['CourseCode']:
                                course_prereq_list.append({
                                    'course_code': line['CourseCode'],
                                    'prereq_code': prereq_code
                                })
                else:
                    course_prereq_list.append({
                        'course_code': line['CourseCode'],
                        'prereq_code': line['Prerequisite']
                    })
    return course_list, course_grade_map, course_prereq_list
