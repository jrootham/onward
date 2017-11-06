import os

BASE_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..')

def pad_front_with_zeros(code_string, full_length):
    return '0' * (full_length - len(code_string)) + code_string

def pad_end_with_zeros(code_string, full_length):
    return code_string + '0' * (full_length - len(code_string))
