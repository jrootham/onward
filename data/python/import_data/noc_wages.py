import csv
import os
import re
from statistics import mean
from pprint import pprint

from data_manipulation_basics import *

REGEX = r'\d{4}'
# Constants for calculating yearly full-time salary
HOURS_PER_WEEK = 37.5
WEEKS_PER_YEAR = 52
# Values to ignore in wage data
BAD_WAGE = ('x', '', 'F', '..', None)

WAGE_FILE = 'additional/cansim-2850003-eng-5656816698728563117.csv'


def update_noc_codes_from_wages(noc_code_list, noc_jobs_list,
                                file_name=WAGE_FILE, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    with open(file_path, encoding=encoding) as f:
        for _ in range(3):
            next(f)
        reader = csv.DictReader(f)
        for line in reader:
            try:
                noc_match = re.search(
                    REGEX, line['National Occupational Classification (3)']
                )
            except TypeError:
                noc_match = None
            if noc_match:
                noc_code = noc_match.group(0)
                description_en = line[
                    'National Occupational Classification (3)'
                ][:noc_match.start()].strip()
                if noc_code not in noc_code_list:
                    noc_code_list[noc_code] = {
                        'noc_code': noc_code,
                        'base_description_en': description_en,
                        'base_description_fr': None
                    }
                    noc_jobs_list.append({
                        'noc_code': noc_code,
                        'job_desc_en': description_en,
                        'job_desc_fr': 'à rechercher'
                    })
                if not noc_code_list[noc_code]['base_description_en']:
                    noc_code_list[noc_code]['base_description_en'] = description_en


def import_noc_wages(file_name=WAGE_FILE, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    noc_wage_data = []
    with open(file_path, encoding=encoding) as f:
        for _ in range(3):
            next(f)
        reader = csv.DictReader(f)
        for line in reader:
            try:
                noc_match = re.search(
                    REGEX, line['National Occupational Classification (3)']
                )
            except TypeError:
                noc_match = None
            if noc_match:
                noc_code = noc_match.group(0)
                wages = []
                wages.append(
                    float(line['Q1 2016']) if line['Q1 2016'] not in BAD_WAGE else None
                )
                wages.append(
                    float(line['Q2 2016']) if line['Q2 2016'] not in BAD_WAGE else None
                )
                wages.append(
                    float(line['Q3 2016']) if line['Q3 2016'] not in BAD_WAGE else None
                )
                wages.append(
                    float(line['Q4 2016']) if line['Q4 2016'] not in BAD_WAGE else None
                )
                wages.append(
                    float(line['Q1 2017']) if line['Q1 2017'] not in BAD_WAGE else None
                )
                wages.append(
                    float(line['Q2 2017']) if line['Q2 2017'] not in BAD_WAGE else None
                )

                wages = [i for i in wages if i is not None]
                if len(wages):
                    hourly_wage = mean(wages)
                    yearly_wage = int(hourly_wage *
                                      HOURS_PER_WEEK *
                                      WEEKS_PER_YEAR)
                else:
                    hourly_wage = yearly_wage = None
                noc_wage_data.append({
                    'noc_code': noc_code,
                    'hourly_wage': hourly_wage,
                    'yearly_wage': yearly_wage
                })
    return noc_wage_data
