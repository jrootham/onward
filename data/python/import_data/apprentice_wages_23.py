import csv
import os

import pprint  # Used for testing -> printing results prettily - can remove

from data_manipulation_basics import *

NOC_LIST = 'Student-Pathways-Challenge-All-Data-v2-utf8/7 - Apprenticeship/23-Ontario-Apprenticeship-Wages-Vacancies-utf8/23-Ontario-Apprenticeship-Wages-Vacancies-Dict-utf8.txt'
WAGES = 'Student-Pathways-Challenge-All-Data-v2-utf8/7 - Apprenticeship/23-Ontario-Apprenticeship-Wages-Vacancies-utf8/23-Ontario-Apprenticeship-Wages-Vacancies-utf8.csv'

def update_noc_codes_from_dict(noc_code_list,
                               noc_jobs_list,
                               file_name=NOC_LIST,
                               encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    with open(file_path, encoding=encoding) as f:
        for _ in range(3):
            next(f)
        for line in f:
            noc_code = line[:5].strip()
            if noc_code == '':
                return
            # pad non-4-digit NOC codes
            noc_code = pad_front_with_zeros(noc_code, 4)
            description_en = line[5:125].strip()
            description_fr = line[125:].strip()
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


def load_noc_wages(file_name=WAGES, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    wages_data = []
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f)
        for line in reader:
            line['NOC'] = pad_front_with_zeros(line['NOC'], 4)
            if line['Vacancies'] == '':
                line['Vacancies'] = None
            else:
                print(line['Vacancies'])
            wages_data.append(line)
    return wages_data
