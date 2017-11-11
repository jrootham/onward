import csv
import os

from pprint import pprint  # Used for testing -> printing results prettily - can remove

from data_manipulation_basics import *

UNIV_PROGRAMS = 'Student-Pathways-Challenge-All-Data-v2-utf8/1 - Wages & Earnings/2-University-Graduate-Salaries-utf8/univ-programs-2.txt'
UNIV_NOC_JOBS = 'Student-Pathways-Challenge-All-Data-v2-utf8/6 - Employment/18-University-Program-NOC-utf8/18-University-Program-NOC-utf8.csv'
NOC_LIST = 'Student-Pathways-Challenge-All-Data-v2-utf8/6 - Employment/18-University-Program-NOC-utf8/18-University-Program-NOC-Dict-utf8.txt'
SPECIFIC_PROGRAM = 'Student-Pathways-Challenge-All-Data-v2-utf8/6 - Employment/21-NOC-Education-utf8/21-NOC-Education-Dict-utf8.txt'
NOC_SPECIFIC_PROGRAM = 'Student-Pathways-Challenge-All-Data-v2-utf8/6 - Employment/21-NOC-Education-utf8/21-NOC-Education-utf8.csv'

# Not worth the overhead to import
credentials = [
    {'credential_code': 'ATC',
     'description_en': "Apprenticeship or trades certificate or diploma",
     'description_fr': "Certificat ou diplôme technique ou d'apprentissage"},
    {'credential_code': 'BDE',
     'description_en': "Bachelor's degree",
     'description_fr': "Baccalauréat"},
    {'credential_code': 'CCO',
     'description_en': "College, CEGEP or other non-university certificate or diploma",
     'description_fr': "Certificat ou diplôme non-universitaire"},
    {'credential_code': 'CDB',
     'description_en': "University certificate or diploma below bachelor level",
     'description_fr': "Certificat ou diplôme universitaire inférieur au baccalauréat"},
    {'credential_code': 'CDD',
     'description_en': "University certificate, diploma or degree above bachelor level",
     'description_fr': "Certificat ou diplôme universitaire supérieur au baccalauréat"},
    {'credential_code': 'HSD',
     'description_en': "High school diploma or equivalent",
     'description_fr': "Études secondaires ou equivalent"},
    {'credential_code': 'NCD',
     'description_en': "No certificate, diploma or degree",
     'description_fr': "Aucun certificat ou diplôme"},
]


def import_univ_programs(file_name=UNIV_PROGRAMS, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f,
                                fieldnames=('program_code',
                                            'description_en',
                                            'description_fr'),
                                quotechar='"',
                                delimiter=' ')
        return list(reader)


def update_noc_codes_from_dict(noc_code_list,
                               noc_jobs_list,
                               file_name=NOC_LIST,
                               encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    with open(file_path, encoding=encoding) as f:
        # skip first 35 lines of file - other info not wanted here
        for _ in range(35):
            next(f)
        for line in f:
            noc_code = line[:5].strip()
            # list ends with non-numberic codes - we don't want those or anything after
            if noc_code.isalpha():
                return
            # the nocs with less than 4 digits are too broad - ignore
            if len(noc_code) < 4:
                continue
            description_en = line[5:268].strip()
            description_fr = line[268:].strip()
            if noc_code not in noc_code_list:
                noc_code_list[noc_code] = {
                    'noc_code': noc_code,
                    'base_description_en': description_en,
                    'base_description_fr': description_fr
                }
                noc_jobs_list.append({
                    'noc_code': noc_code,
                    'job_desc_en': description_en,
                    'job_desc_fr': description_fr
                })
            if not noc_code_list[noc_code]['base_description_en']:
                noc_code_list[noc_code]['base_description_en'] = description_en
            if not noc_code_list[noc_code]['base_description_fr']:
                noc_code_list[noc_code]['base_description_fr'] = description_fr


def import_univ_noc_employment(file_name=UNIV_NOC_JOBS, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    data_dict = {}
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f)
        for line in reader:
            noc_code = line['NOC'].strip()
            # nb - need to ignore anything with noc code of C or U
            if noc_code.isalpha() or len(noc_code) < 4:
                continue
            line_key = line['Year'] + line['Program'] + noc_code
            # also, in some cases the same noc code is repeated for the same program - need to total per year
            if line_key in data_dict:
                data_dict[line_key]['employed'] += int(line['Employed'])
                data_dict[line_key]['self_employed'] += int(line['Self-Employed'])
            else:
                data_dict[line_key] = {
                    'year': line['Year'],
                    'program_code': line['Program'],
                    'noc_code': noc_code,
                    'employed': int(line['Employed']),
                    'self_employed': int(line['Self-Employed'])
                }
    return list(data_dict.values())

# TODO: These need to be linked to univ_program (more general) codes
def import_univ_program_specific(file_name=SPECIFIC_PROGRAM, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    program_details = []
    with open(file_path, encoding=encoding) as f:
        for _ in range(521):
            next(f)
        for line in f:
            specific_code = line[:5].strip()
            if specific_code == '':
                break
            description_en = line[5:106].strip()
            description_fr = line[106:].strip()
            program_details.append({
                'specific_code': specific_code,
                'description_en': description_en,
                'description_fr': description_fr
            })
    return program_details


def import_noc_specific_program(file_name=NOC_SPECIFIC_PROGRAM, encoding='utf-8'):
    """
    This amalgamates job numbers for 15-24 and 24-35 into one database entry
    """
    file_path = os.path.join(BASE_PATH, file_name)
    data_dict = {}
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f)
        for line in reader:
            noc_code = line['Occupation'].strip()
            if noc_code.isalpha() or len(noc_code) < 4:
                continue
            if line['AgeGroup'] not in ('15-24', '25-34'):
                continue
            line_key = noc_code + line['Credential'] + line['Program']
            if line_key in data_dict:
                data_dict[line_key]['job_count'] += int(line['Count'])
            else:
                data_dict[line_key] = {
                    'noc_code': noc_code,
                    'credential_code': line['Credential'].strip(),
                    'specific_program_code': line['Program'],
                    'job_count': int(line['Count'])
                }
    return list(data_dict.values())
