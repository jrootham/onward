import os
import re

from data_manipulation_basics import *

regex = r''

def load_codes_from_file(file_id, encoding='utf-8'):
    file_path = os.path_join(BASE_PATH)
    with open(file_path, encoding=encoding) as f:
