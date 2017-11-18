import pymysql as mysql

from pprint import pprint

from export_to_mysql.db_secrets import *

if ENGINE == 'MySQL':
    VARCHAR_LIMIT = 255
    LONG_VARCHAR = 254
else:
    VARCHAR_LIMIT = 750
    LONG_VARCHAR = 3000

connection = mysql.connect(host=HOST,
                           password=PASSWORD,
                           port=PORT,
                           user=USER,
                           db=DB)

def write_noc_codes(noc_uniques):
    sql = 'INSERT INTO noc_uniques ' \
            '(noc_code, base_description_en, base_description_fr) ' \
            'VALUES (%s, %s, %s)'
    with connection.cursor() as cursor:
        for noc_code in noc_uniques:
            cursor.execute(sql, (noc_code['noc_code'],
                                 noc_code['base_description_en'][:VARCHAR_LIMIT],
                                 noc_code['base_description_fr'][:VARCHAR_LIMIT]))
    connection.commit()


def write_noc_jobs(noc_jobs):
    sql = 'INSERT INTO noc_codes ' \
            '(noc_code, description_en, description_fr) ' \
            'VALUES (%s, %s, %s)'
    with connection.cursor() as cursor:
        for noc_job in noc_jobs:
            cursor.execute(sql, (noc_job['noc_code'],
                                 noc_job['job_desc_en'][:VARCHAR_LIMIT],
                                 noc_job['job_desc_fr'][:VARCHAR_LIMIT]))
    connection.commit()


def write_task_list(task_list):
    sql = 'INSERT INTO noc_tasks ' \
            '(task_code, description_en, description_fr) ' \
            'VALUES (%s, %s, "Description à venir")'
    with connection.cursor() as cursor:
        for task in task_list:
            cursor.execute(sql, (
                task['task_code'],
                task['task_en'][:LONG_VARCHAR].encode('ascii', 'ignore')
            ))
    connection.commit()


def write_skill_list(skill_list):
    sql = 'INSERT INTO noc_skills ' \
            '(skill_code, description_en, description_fr) ' \
            'VALUES (%s, %s, %s)'
    with connection.cursor() as cursor:
        for skill in skill_list:
            cursor.execute(sql, (
                skill['skill_code'],
                skill['description_en'][:VARCHAR_LIMIT].encode('ascii', 'ignore'),
                skill['description_fr'][:VARCHAR_LIMIT].encode('ascii', 'ignore')
            ))
    connection.commit()


def write_skill_level_list(skill_level_list):
    sql = 'INSERT INTO noc_skills_levels ' \
            '(skill_code, level_code, description_en, description_fr) ' \
            'VALUES (%s, %s, %s, %s)'
    with connection.cursor() as cursor:
        for skill_level in skill_level_list:
            cursor.execute(sql, (
                skill_level['skill_code'],
                skill_level['level_code'],
                skill_level['description_en'][:VARCHAR_LIMIT].encode('ascii', 'ignore'),
                skill_level['description_fr'][:VARCHAR_LIMIT].encode('ascii', 'ignore')
            ))
    connection.commit()


def write_skills_education(noc_skills_education):
    sql = 'INSERT INTO noc_skills_education ' \
            '(education_training_code, description_en, description_fr) ' \
            'VALUES (%s, %s, %s)'
    with connection.cursor() as cursor:
        for skill in noc_skills_education:
            cursor.execute(sql, (
                skill['education_training_code'],
                skill['description_en'],
                skill['description_fr']
            ))
    connection.commit()


def write_skills_tasks_education_map(noc_skills_tasks_list):
    sql = 'INSERT INTO noc_skills_tasks ' \
            '(task_code, noc_code, skill_code, skill_level, education_training) ' \
            'VALUES (%s, %s, %s, %s, %s)'
    failed_nocs = set()
    all_nocs = set()
    with connection.cursor() as cursor:
        for skill in noc_skills_tasks_list:
            all_nocs.add(skill['NOC'])
            if skill['EducationTrainingLevel'] not in ('M', 'A', 'B', 'C/D'):
                skill['EducationTrainingLevel'] = None
            try:
                cursor.execute(sql, (
                    skill['TaskCode'],
                    skill['NOC'],
                    skill['Skill'],
                    skill['SkillLevel'],
                    skill['EducationTrainingLevel']
                ))
            except mysql.err.IntegrityError as e:
                failed_nocs.add(skill['NOC'])
    # print('NOC ERRORS: ', len(failed_nocs))
    # print('All Nocs: ', len(all_nocs))
    connection.commit()


def write_automation_risk(input_list):
    sql = 'INSERT INTO automation_risk ' \
            '(noc_code, automation_risk) ' \
            'VALUES (%s, %s)'
    with connection.cursor() as cursor:
        for item in input_list:
            cursor.execute(sql, (item['NOC'],
                                 item['AutomationProbability']))
    connection.commit()


def write_noc_wages(input_list):
    sql = 'INSERT INTO noc_wages ' \
            '(noc_code, hourly_wage, yearly_wage) ' \
            'VALUES (%s, %s, %s)'
    with connection.cursor() as cursor:
        for item in input_list:
            cursor.execute(sql, (item['noc_code'],
                                 item['hourly_wage'],
                                 item['yearly_wage']))
    connection.commit()


def write_apprentice_wages(input_list):
    sql = 'INSERT INTO apprentice_noc_wages_openings ' \
            '(noc_code, year, avg_hourly_wage, vacancies) ' \
            'VALUES (%s, %s, %s, %s)'
    with connection.cursor() as cursor:
        for item in input_list:
            cursor.execute(sql, (item['NOC'],
                                 item['Year'],
                                 item['AvgHourlyWage'],
                                 item['Vacancies']))
    connection.commit()
