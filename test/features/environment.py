from smtplib import *
import time
import _mysql
import os


def before_all(context):
    max_retries = 100

    # this really sucks postfix..
    # permanent "temporary lookup failure" hits you for infinite DMG
    for attempt in range(max_retries):
        try:
            db = _mysql.connect(host=os.getenv('POSTFIX_MYSQL_HOST'), user=os.getenv('POSTFIX_MYSQL_USERNAME'),
                                passwd=os.getenv('POSTFIX_MYSQL_PASSWORD'), db=os.getenv('POSTFIX_MYSQL_DBNAME'))
            db.query("SELECT id FROM virtual_users")
            break
        except:
            time.sleep(1)

    for attempt in range(max_retries):
        try:
            server = SMTP('smtp')
            server.close()
            return
        except:
            time.sleep(1)
    # We should not end up here, fail
    assert False
