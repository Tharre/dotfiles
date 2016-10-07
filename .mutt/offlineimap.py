#!/bin/python
from subprocess import check_output

def get_pass(account):
    return check_output("pass email/"+account, shell=True).rstrip()
