from smtplib import *
import time
import os


def before_all(context):
    max_retries = 100
    for attempt in range(max_retries):
        try:
            server = SMTP('smtp')
            server.close()
            return
        except:
            time.sleep(1)
    # We should not end up here, fail
    assert False
