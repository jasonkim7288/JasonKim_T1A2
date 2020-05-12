<h1 align="center"> Gmail application
</h1>

# Table of Contents
* [R4 - Source link](#R4---Source-link)
* [R5 - Purpose and scope](#R5---Purpose-and-scope)
* [R6 - Features](#R6---Features)
* [R7 - User interaction and experience](#R7---User-interaction-and-experience)
* [R8 - Control flow](#R8---Control-flow)
* [R9 - Implementation plan](#R9---Implementation-plan)
* [R10 - Installation guide and requirement](#R10---Installation-guide-and-requirement)
<br /><br /><br />

# R4 - Source link
Source code is in https://github.com/jasonkim7288/ruby_gmail_terminal_app<br /><br />

[Go back](#table-of-contents)<br /><br /><br />

# R5 - Purpose and scope
Gmail application will manage your Gmail account, show the email list after logged in, show the content of each email, and also let you create a new email with an file attachment. All those functions can be done with a simple command-line interface (CLI).<br />
Users can access their Gmail accounts and check the email without any browser and even send a simple email with a file attached. It will be a good idea to use this Gmail application if you are a computer server manager which has only command line UNIX environment or if your browser has been infected by any serious virus so you cannot use it.<br />
Once a simple security setting is changed, it is free to access Gmail anytime on command prompt.<br />

[Go back](#table-of-contents)<br /><br /><br />

# R6 - Features
## Manage Gmail account
Gmail application is able to manage the Gmail account. Once you log in with your existing Gmail account, the application automatically store the account name into a file and show the account name list after next log-in.<br />
If the account you logged in is not supposed to be stored, there is a command for deleting the account which is just removing the account name from the local file not removing the real Gmail account from the server.<br /> 

## Display email list
Once Gmail application succeeds in log-in, it will display the current account name logged in, the current label of the mailbox, an email list, and the current page of the mailbox.<br />
Every label is from Gmail server, so you can see the exact same label from browser, and default label of the mailbox is "INBOX". Each labeled mailbox has an email list showing email number, sender, subject and a little bit of body.<br />
You can navigate each label of the mailbox and the pages if there are more than 7 mails in the mailbox. If there is an email that interests you, "View the mail" will display the detailed content.<br />

## Create a new email
On the mail list screen, there is an option for creating a new email that allow you to send a simple email to anyone.<br />
Once whom to send, and what the subject is have been submitted, message body part can be written with a html format. You can still use only text except writing "\<br />" to make a new line ('Enter' key is not working).<br />
There is also a special function that "File attachment" is available if wanted. The file name has to include exact file path.

[Go back](#table-of-contents)<br /><br /><br />

# R7 - User interaction and experience

## User interacion
When started, navigate the menu as below

![Decision tree](docs/DecisionTree_JasonKim_T1A2.png)

## User experience
This Gmail program uses IMAP(Internet Message Access Protocol), so it will be much slower than the original Gmail app using [Google's official Gmail API Ruby Client](https://developers.google.com/gmail/api/quickstart/ruby).

[Go back](#table-of-contents)<br /><br /><br />

# R8 - Control flow
## Flowchart
<details>
<summary>
<strong>Click for the flowchart</strong>
</summary>

![JasonKim_T1A2_diagram.png](docs/JasonKim_T1A2_diagram.png)
</details>


## Pseudo code
```
Begin
    loop1:
        read google account id list from file
        print app title
        print account list
        input choice for account list
        if select "log in with an existing account"
            input password
        else if select "log in with a new account"
            input id
            input password
        else if select "remove an account"
            remove the existing account
            goto loop1
        else if select "exit"
            exit
        else
            goto loop1
        end if

        log in
        if is log in succeed
    loop2:
            load mail list
        else
            goto loop1
            print app title
            print mail list
            input choice for mail list
            if select "change label"
                change the label
        end if
    

End
```

[Go back](#table-of-contents)<br /><br /><br />

# R9 - Implementation plan
## Outlines
![trello start](docs/Trello_start.png)
## Project management
Platform : Trello<br />
Project board : [http://trello.com/b/87EDzcri/jasonkimt1a2](http://trello.com/b/87EDzcri/jasonkimt1a2)

[Go back](#table-of-contents)<br /><br /><br />

# R10 - Installation guide and requirement
## Get started
* This installation guide is for Mac users
1. Your google account MUST less secure app access as follows through the browser.<br />
go to Google account -> Select "Manage your Google Account" -> Select "Security" -> Select "Turn on access(not recommended)" in "Less secure app access" -> Turn on "Allow less secure apps: "

<details>
<summary>
<strong>Click for the detailed steps</strong>
</summary>

![Step 1](docs/GmailAccountSecuritySetting_1.png)
![Step 2](docs/GmailAccountSecuritySetting_2.png)
![Step 3](docs/GmailAccountSecuritySetting_3.png)
![Step 4](docs/GmailAccountSecuritySetting_4.png)
![Step 5](docs/GmailAccountSecuritySetting_5.png)
</details>

2. If you don't have Ruby installed, you can download it and follow the installation instructions available [here](https://www.ruby-lang.org/en/documentation/installation/).

3. If you don't have bunlder gem, run as below
```
gem install bundler
```

4. Unzip the submission zip file to your home directory

5. Change your working directory to the project source directory
```
[~]$ cd ~/JasonKim_T1A2/src
```
6. Just in case of the failure of running './run_gmail.sh', you need to install Homebrew and run the command as below
```
[~/JasonKim_T1A2/src]$ brew install icu4c
```
7. Run the script for Gmail application

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7-1. Run the default script
```
[~/JasonKim_T1A2/src]$ ./run_gmail.sh
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7-2. If you want to EXPOSE your gmail account and password to the author for fun, run the script as below
```
[~/JasonKim_T1A2/src]$ ./run_gmail.sh -f
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7-3. If you want to change the number of rows of the mail list, run the scripts as below. The number should be between 1 and 50
```
[~/JasonKim_T1A2/src]$ ./run_gmail.sh -n 20
```
## Dependencies
### Gems required
- gmail
- html_massage
- tty-table
- tty-prompt
- tty-font
- pastel
- colorize
- test-unit

[Go back](#table-of-contents)<br /><br /><br />
