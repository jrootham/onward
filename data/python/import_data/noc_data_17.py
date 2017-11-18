import csv
import os

import pprint  # Used for testing -> printing results prettily - can remove

from data_manipulation_basics import *

NOC_FILE = 'additional/NOC_codes_2011.csv'
TASKS_EN = 'Student-Pathways-Challenge-All-Data-v2-utf8/5 - Labour Market/17-Essential-Skills-CompÇtences-ClÇs-utf8/17-tasks-en-utf8.txt'
TASKS_FR = 'Student-Pathways-Challenge-All-Data-v2-utf8/5 - Labour Market/17-Essential-Skills-CompÇtences-ClÇs-utf8/17-tasks-fr-utf8.txt'
SKILLS_EN = 'Student-Pathways-Challenge-All-Data-v2-utf8/5 - Labour Market/17-Essential-Skills-CompÇtences-ClÇs-utf8/17-skills-en-utf8.txt'
SKILLS_FR = 'Student-Pathways-Challenge-All-Data-v2-utf8/5 - Labour Market/17-Essential-Skills-CompÇtences-ClÇs-utf8/17-skills-fr-utf8.txt'
NOC_SKILLS_TASKS_EN = 'Student-Pathways-Challenge-All-Data-v2-utf8/5 - Labour Market/17-Essential-Skills-CompÇtences-ClÇs-utf8/17-Essential-Skills-utf8.csv'
NOC_CODES_FROM_TXT_EN = 'Student-Pathways-Challenge-All-Data-v2-utf8/5 - Labour Market/17-Essential-Skills-CompÇtences-ClÇs-utf8/17-noc_codes_en.txt'
NOC_CODES_FROM_TXT_FR = 'Student-Pathways-Challenge-All-Data-v2-utf8/5 - Labour Market/17-Essential-Skills-CompÇtences-ClÇs-utf8/17-noc_codes_fr.txt'


# Transcribed rather than imported - is in the dict.txt file for dataset 17
noc_skills_education = [
    {'education_training_code': 'M',
     'description_en': 'University Degree(s) (Management)',
     'description_fr': 'Diplôme universitaire (gestion)'},
    {'education_training_code': 'A',
     'description_en': 'University Degree(s)',
     'description_fr': 'Diplôme universitaire'},
    {'education_training_code': 'B',
     'description_en': 'College, vocational, or apprenticeship',
     'description_fr': 'Diplôme collégial, à finalité professionnelle, ou apprentissage'},
    {'education_training_code': 'C/D',
     'description_en': 'Secondary school and/or occupation-specific training and/or On the job training, no formal education',
     'description_fr': "École secondaire et/ou formation en cours d'emploi et/ou formation en cours d'emploi, aucune éducation formelle"},
]


def load_all_noc_codes(file_name=NOC_FILE, encoding='utf-8'):
    """
    returns noc_code dictionary - noc_code as key,
            with empty french & english descriptions
    return noc_jobs list - noc code with french & english job title
    """
    file_path = os.path.join(BASE_PATH, file_name)
    noc_codes = {}
    noc_jobs = []
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f)
        for line in reader:
            if line['Element_Type'] == '19':  # Change this to '10' for only illustrative examples
                if line['Classification Code'] not in noc_codes:
                    noc_codes[line['Classification Code']] = {
                        'noc_code': line['Classification Code'],
                        'base_description_en': None,
                        'base_description_fr': None,
                    }
                noc_jobs.append({
                    'noc_code': line['Classification Code'],
                    'job_desc_en': line['Element Description English'],
                    'job_desc_fr': line['Element Description French']
                })
    return noc_codes, noc_jobs


def load_noc_tasks(file_name_en=TASKS_EN, file_name_fr=TASKS_FR, encoding='utf-8'):
    # N.B. in both these files, the code is divided from description with a tab
    file_path_en = os.path.join(BASE_PATH, file_name_en)
    file_path_fr = os.path.join(BASE_PATH, file_name_fr)
    task_dict = {}
    task_list = []
    with open(file_path_en, encoding=encoding) as f:
        reader = csv.DictReader(f,
                                fieldnames=('task_code', 'task_en'),
                                delimiter='\t')
        for line in reader:
            task_dict[line['task_code']] = {'task_en': line['task_en']}
    for key in task_dict:
        task_list.append({**{'task_code': key},
                          **task_dict[key],
                          **{'task_fr': None}})
    return task_list


def load_noc_skills(file_name_en=SKILLS_EN, file_name_fr=SKILLS_FR, encoding='utf-8'):
    file_path_en = os.path.join(BASE_PATH, file_name_en)
    file_path_fr = os.path.join(BASE_PATH, file_name_fr)
    skill_dict = {}
    skill_list = []
    skill_level_list = []
    with open(file_path_en, encoding=encoding) as f:
        current_skill_code = None
        for line in f:
            if line[0] == 'S':
                current_skill_code = line[:3].strip()
                skill_dict[current_skill_code] = {'skill_en': line[3:].strip(),
                                                  'levels': {}}
            elif line[:2] == '->':
                skill_dict[current_skill_code]['levels'][line[2:5].strip()] ={
                    'skill_level_en': line[5:].strip()
                }
    with open(file_path_fr, encoding=encoding) as f:
        current_skill_code = None
        for line in f:
            if line[0] == 'S':
                current_skill_code = line[:3].strip()
                skill_dict[current_skill_code]['skill_fr'] = line[3:].strip()
            elif line[:2] == '->':
                skill_dict[current_skill_code]['levels'][line[2:5].strip()] \
                        ['skill_level_fr'] = line[5:].strip()
    for key in skill_dict:
        skill_list.append({'skill_code': key,
                           'description_en': skill_dict[key]['skill_en'],
                           'description_fr': skill_dict[key]['skill_fr']})
        for level_key in skill_dict[key]['levels']:
            skill_level_list.append({
                'skill_code': key,
                'level_code': level_key,
                'description_en': skill_dict[key]['levels'][level_key]['skill_level_en'],
                'description_fr': skill_dict[key]['levels'][level_key]['skill_level_fr']
            })
    return skill_list, skill_level_list


def load_noc_skills_tasks(file_name_en=NOC_SKILLS_TASKS_EN, encoding='utf-8'):
    file_path_en = os.path.join(BASE_PATH, file_name_en)
    # NOTE: French Data is very different.  Needs to be dealt with more effectively
    noc_skills_tasks_list = []
    with open(file_path_en, encoding=encoding) as f:
        reader = csv.DictReader(f)
        for line in reader:
            if line['NOC'][-1].isalpha():
                line['NOC'] = line['NOC'][:-1]
            line['NOC'] = pad_front_with_zeros(line['NOC'], 4)
            line['TaskCode'] = pad_front_with_zeros(line['TaskCode'], 5)
            if line['EducationTrainingLevel'] not in ('M', 'A', 'B', 'C/D'):
                line['EducationTrainingLevel'] = None
            noc_skills_tasks_list.append(line)
    return noc_skills_tasks_list


def update_noc_codes_from_skill_tasks(noc_code_list,
                                      noc_jobs_list,
                                      file_name_en=NOC_CODES_FROM_TXT_EN,
                                      file_name_fr=NOC_CODES_FROM_TXT_FR,
                                      encoding='utf-8'):
    """
    This function updates the noc code listing based on what's in the dict.txt
    files in 2 ways:
    1) Adds noc codes that are mentioned in the data, but arent' in stats can's
        master list
    2) updates the default french and english names for the jobs if not aleady set
    """
    file_path_en = os.path.join(BASE_PATH, file_name_en)
    file_path_fr = os.path.join(BASE_PATH, file_name_fr)
    new_nocs = {}
    with open(file_path_en, encoding=encoding) as f:
        for line in f:
            noc_code = line[:5].strip()
            description_en = line[5:].strip()
            if noc_code[-1].isalpha():
                noc_code = noc_code[:-1]
            noc_code = pad_front_with_zeros(noc_code, 4)
            if noc_code not in noc_code_list:
                noc_code_list[noc_code] = {
                    'noc_code': noc_code,
                    'base_description_en': description_en,
                    'base_description_fr': None
                }
                new_nocs[noc_code] = {
                    'noc_code': noc_code,
                    'job_desc_en': description_en,
                    'job_desc_fr': None
                }
            elif not noc_code_list[noc_code]['base_description_en']:
                noc_code_list[noc_code]['base_description_en'] = description_en
    with open(file_path_fr, encoding=encoding) as f:
        for line in f:
            noc_code = line[:5].strip()
            description_fr = line[5:].strip()
            if noc_code[-1].isalpha():
                noc_code = noc_code[:-1]
            noc_code = pad_front_with_zeros(noc_code, 4)
            if noc_code not in noc_code_list:
                noc_code_list[noc_code] = {
                    'noc_code': noc_code,
                    'base_description_en': None,
                    'base_description_fr': description_fr
                }
                new_nocs[noc_code] = {
                    'noc_code': noc_code,
                    'job_desc_en': None,
                    'job_desc_fr': description_fr
                }
            elif not noc_code_list[noc_code]['base_description_fr']:
                noc_code_list[noc_code]['base_description_fr'] = description_fr
            if noc_code in new_nocs:
                new_nocs[noc_code]['job_desc_fr'] = description_fr
    for key in new_nocs:
        noc_jobs_list.append(new_nocs[key])


#
#
# if __name__ == '__main__':
#     noc_codes, noc_jobs = load_all_noc_codes(NOC_FILE, 'windows-1252')
#     task_list = load_noc_tasks(TASKS_EN, TASKS_FR)
#     skill_list, skill_level_list = load_noc_skills(SKILLS_EN, SKILLS_FR)
#     noc_skills_tasks_list = load_noc_skills_tasks(NOC_SKILLS_TASKS_EN)
#     update_noc_codes_from_skill_tasks(noc_codes)
