from behave import *
from smtplib import *
import os
import uuid
import gzip
import logging
import time


@given(u'{sender} wants to send an e-mail to {receiver}')
def step_impl(context, sender, receiver):
    context.sender = sender
    context.receiver = receiver
    context.server = SMTP('smtp')
    context.server.set_debuglevel(1)
    context.message_id = str(uuid.uuid1())
    context.message = """From: {sender}
To: {receiver}
Subject: {message_id}

yupp
""".format(receiver=receiver, sender=sender, message_id=context.message_id)


@when(u'the sender attempts to send the e-mail')
def step_impl(context):
    try:
        context.server.sendmail(context.sender, [context.receiver], context.message)
        context.send_succeeded = True
    #except (SMTPRecipientsRefused, SMTPHeloError, SMTPSenderRefused, SMTPDataError, SMTPNotSupportedError) as e:
    except:
        context.send_succeeded = False
    context.server.quit()


@then(u'the e-mail should be accepted')
def step_impl(context):
    assert context.send_succeeded


@then(u'the e-mail should appear in the receivers mailbox')
def step_impl(context):
    found = False
    max_retries = 20
    username = context.receiver.split("@")[0]
    for attempt in range(max_retries):
        for dir_path, subdir_list, file_list in os.walk(os.path.join("/mail", username, "Maildir", "new")):
            for fname in file_list:
                with gzip.open(os.path.join(dir_path, fname), 'r') as f:
                    message_lines = f.read().splitlines()
                    if "Subject: {}".format(context.message_id).encode('ascii') in message_lines:
                        found = True
                        break
        if found:
            break
        time.sleep(1)
    assert found
