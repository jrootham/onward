from import_data import noc_data_17, university_program_noc_18, noc_wages
from import_data import automation_22, apprentice_wages_23
from import_data import high_school_courses
from import_data.colleges import college_main
from export_to_mysql import export_all_noc_data, export_univ_data, export_hs
from pprint import pprint  # for printing pretty result while testing


def process_noc_codes():
    """
    noc_codes maps to noc_uniques in database
    noc_jobs maps to noc_codes in database
    """
    # Import base noc data
    noc_codes, noc_jobs = noc_data_17.load_all_noc_codes(encoding='windows-1252')
    # udpate based on misc. dicts provided
    noc_data_17.update_noc_codes_from_skill_tasks(noc_codes, noc_jobs)
    university_program_noc_18.update_noc_codes_from_dict(noc_codes, noc_jobs)
    automation_22.update_noc_codes_from_dict(noc_codes, noc_jobs)
    apprentice_wages_23.update_noc_codes_from_dict(noc_codes, noc_jobs)
    noc_wages.update_noc_codes_from_wages(noc_codes, noc_jobs,
                                          encoding='windows-1252')

    # write to database
    noc_codes = list(noc_codes.values())
    # add placeholder values to noc_code descriptions
    for code in noc_codes:
        if code['base_description_en'] in ('', None):
            code['base_description_en'] = 'Missing Data'
        if code['base_description_fr'] in ('', None):
            code['base_description_fr'] = 'à rechercher'
    export_all_noc_data.write_noc_codes(noc_codes)
    export_all_noc_data.write_noc_jobs(noc_jobs)

    print('\n\nNOC codes processed\n\n')


def process_noc_skills_tasks():
    """
    task_list maps to noc_tasks in database
    skill_list maps to noc_skills in database
    skill_level_list maps to noc_skills_levels in database
    noc_skills_education maps to noc_skills_education in database
    noc_skills_tasks_lists maps to noc_skills_tasks in database
    """
    # Import relevant data
    task_list = noc_data_17.load_noc_tasks()
    skill_list, skill_level_list = noc_data_17.load_noc_skills()
    noc_skills_education = noc_data_17.noc_skills_education
    noc_skills_tasks_list = noc_data_17.load_noc_skills_tasks()
    # Write to database
    export_all_noc_data.write_task_list(task_list)
    export_all_noc_data.write_skill_list(skill_list)
    export_all_noc_data.write_skill_level_list(skill_level_list)
    export_all_noc_data.write_skills_education(noc_skills_education)
    export_all_noc_data.write_skills_tasks_education_map(noc_skills_tasks_list)

    print('NOC Skills Tasks Processed\n\n')


def process_university_noc_data():
    """
    univ_programs maps to sql table univ_programs
    univ_program_noc_employment maps to sql table univ_noc_employment
    credentials maps to sql table credentials
    univ_programs_specific maps to sql table univ_programs_specific
    noc_specific_program maps to sql table noc_specific_program
    """
    # import relevant data
    univ_programs = university_program_noc_18.import_univ_programs()
    univ_program_noc_employment = university_program_noc_18.import_univ_noc_employment()
    credentials = university_program_noc_18.credentials
    univ_programs_specific = university_program_noc_18.import_univ_program_specific()
    noc_specific_program = university_program_noc_18.import_noc_specific_program()
    # write to database
    export_univ_data.write_univ_programs(univ_programs)
    export_univ_data.write_univ_noc_employement(univ_program_noc_employment)
    export_univ_data.write_credentials(credentials)
    export_univ_data.write_univ_programs_specific(univ_programs_specific)
    export_univ_data.write_noc_specific_program(noc_specific_program)

    print('University NOC Data processed \n\n')


def process_misc_noc_data():
    """
    automation_risk maps to sql table automation_risk
    noc_wages maps to sql table noc_wages
    apprentice_wages_data maps to sql table apprentice_noc_wages_openings
    """
    # import data
    automation_risk = automation_22.load_automation_risks()
    noc_wage_list = noc_wages.import_noc_wages(encoding='windows-1252')
    apprentice_wages_data = apprentice_wages_23.load_noc_wages()
    # write to database
    export_all_noc_data.write_automation_risk(automation_risk)
    export_all_noc_data.write_noc_wages(noc_wage_list)
    export_all_noc_data.write_apprentice_wages(apprentice_wages_data)

    print('Misc NOC data processed\n\n')


def process_hs_path():
    course_list, course_grade_map, course_prereq_list = \
            high_school_courses.process_hs_course_tree()
    export_hs.write_hs_courses(course_list)
    export_hs.write_hs_grade_map(course_grade_map)
    export_hs.write_hs_course_prereqs(course_prereq_list)

    print('HS path processesed\n\n')

####################
# From this point forward, files will be processed and saved to db in same fn
####################

def process_colleges():
    # college_main.process_college_univ_list(encoding='mac_roman')
    college_main.process_college_program_list()


def main():
    # process_noc_codes()
    # process_noc_skills_tasks()
    # process_university_noc_data()
    # process_misc_noc_data()
    # process_hs_path()
    process_colleges()


if __name__ == '__main__':
    main()
