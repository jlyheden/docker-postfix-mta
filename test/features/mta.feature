Feature: Receiving e-mail

    Scenario: Mail to existing user
    Given guy.incognito@example.com wants to send an e-mail to john.doe@example.com
    When the sender attempts to send the e-mail
    Then the e-mail should be accepted
    And the e-mail should appear in the receivers mailbox
