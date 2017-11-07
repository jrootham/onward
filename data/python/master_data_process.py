from import_data import noc_data_17, university_program_noc_18
from import_data import automation_22, apprentice_wages_23
from export_to_mysql import export_all_noc_data
import pprint  # for printing pretty result while testing


def process_noc_codes():
    # Import base noc data
    noc_codes, noc_jobs = noc_data_17.load_all_noc_codes(encoding='windows-1252')
    # udpate based on misc. dicts provided
    noc_data_17.update_noc_codes_from_skill_tasks(noc_codes, noc_jobs)
    university_program_noc_18.update_noc_codes_from_dict(noc_codes, noc_jobs)
    automation_22.update_noc_codes_from_dict(noc_codes, noc_jobs)
    apprentice_wages_23.update_noc_codes_from_dict(noc_codes, noc_jobs)

    # write to database
    noc_codes = list(noc_codes.values())
    export_all_noc_data.write_noc_codes(noc_codes)


def process_noc_skills_tasks():
    # Import relevant data
    task_list = noc_data_17.load_noc_tasks()
    skill_list, skill_level_list = noc_data_17.load_noc_skills()
    noc_skills_tasks_list = noc_data_17.load_noc_skills_tasks()
    # Write to database


def process_university_noc_data():
    # import relevant data
    univ_programs = university_program_noc_18.import_univ_programs()
    univ_program_noc_employment = university_program_noc_18.import_univ_noc_employment()
    univ_programs_specific = university_program_noc_18.import_univ_program_specific()
    noc_specific_program = university_program_noc_18.import_noc_specific_program()
    # write to database

def process_misc_noc_data():
    automation_risk = automation_22.load_automation_risks()
    apprentice_wages_data = apprentice_wages_23.load_noc_wages()

def main():
    process_noc_codes()
    # process_noc_skills_tasks()
    # process_university_noc_data()
    process_misc_noc_data()


if __name__ == '__main__':
    main()
