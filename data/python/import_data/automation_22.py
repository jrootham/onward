import csv
import os

import pprint  # Used for testing -> printing results prettily - can remove

from data_manipulation_basics import *

NOC_LIST = 'Student-Pathways-Challenge-All-Data-v2-utf8/6 - Employment/22-Automation-Risk-utf8/22-Automation-Risk-Dict-utf8.txt'
AUTOMATION = 'Student-Pathways-Challenge-All-Data-v2-utf8/6 - Employment/22-Automation-Risk-utf8/22-Automation-Risk-utf8.csv'

def update_noc_codes_from_dict(noc_code_list,
                               noc_jobs_list,
                               file_name=NOC_LIST,
                               encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    with open(file_path, encoding=encoding) as f:
        for _ in range(3):
            next(f)
        for line in f:
            # Stuff is tab delimited - don't know exactly where tab is
            noc_len = 4
            while True:
                noc_code = line[:noc_len].strip()
                if '\t' in noc_code:
                    noc_len -= 1
                else:
                    break

            if noc_code == '':
                return
            # pad non-4-digit NOC codes
            noc_code = pad_front_with_zeros(noc_code, 4)
            en_len = 124 - noc_len
            while True:
                description_en = line[noc_len:en_len].strip()
                if '\t' in description_en:
                    en_len -= 1
                else:
                    break
            description_fr = line[en_len:].strip()
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


def load_automation_risks(file_name=AUTOMATION, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    automation_data = []
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f)
        for line in reader:
            line['NOC'] = pad_front_with_zeros(line['NOC'], 4)
            automation_data.append(line)
    return automation_data
