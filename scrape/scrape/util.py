import os
import re


def parse_cookie(string):
    cookies = {}
    pattern = re.compile(r'^Cookie: (?P<cookie>.*)')
    for cookie in pattern.match(string).groupdict()['cookie'].split(';'):
        k, v = cookie.split('=', 1)
        cookies[k.strip()] = v.strip()
    return cookies


def mkdir(directory):
    try:
        os.makedirs(directory)
    except OSError as e:
        pass
