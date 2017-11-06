import csv
import os
from operator import itemgetter

from data_manipulation_basics import *

TRADES_TO_NOC_FILE = 'Student-Pathways-Challenge-All-Data-v2-utf8/7 - Apprenticeship/26-OCTAA-Chart-utf8/26-OCTAA-Chart-utf8.csv'
TRADES_NAMES = 'additional/trade_codes.txt'

def load_trades_noc_translate(file_name=TRADES_TO_NOC_FILE, encoding='utf-8'):
    file_path = os.path.join(BASE_PATH, file_name)
    translation = []
    trades_dict = {}
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f, quotechar='"')
        for line in reader:
            details = {
                'trade_code': line['TradeCode'],
                'NOC': line['NOC']
            }
            translation.append(details)
            trades_dict[line['TradeCode']] = details
    return translation, trades_dict


def load_trades_data(file_name, encoding='utf-8', trades_details={}):
    file_path = os.path.join(BASE_PATH, file_name)
    with open(file_path, encoding=encoding) as f:
        reader = csv.DictReader(f, delimiter=' ', quotechar='"')
        for line in reader:
            trades_details[line['Trade Code']]['trade_name_en'] = line['Trade Name']
            trades_details[line['Trade Code']]['sector'] = line['Sector']
            trades_details[line['Trade Code']]['classification'] = line['Classification']
            trades_details[line['Trade Code']]['exam_reqd'] = line['CofQ Exam?']
            # print(line)
    return trades_details


def add_new_trades_names(trades_list, noc_jobs, translate_file):
    job_titles = map(itemgetter('job_desc_en'), noc_jobs)
    for trade_code in trades_list:
        job_title_en = trades_list[trade_code]['trade_name_en']
        if (job_title_en) not in job_titles:
            noc_code = translate_file[trade_code]
        else:
            idx = job_titles.index(job_title_en)
            trade_list[trades_code]['trade_name_fr'] = noc_jobs[idx]['job_desc_fr']
