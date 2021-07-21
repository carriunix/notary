# the NOTARY script

## what is it?
    NOTARY is a shell-script based application developed to create and distribute certificates.

    This script was developed for Escola de Física and Semana da Física events, of Instituto de 
    Física of Universidade Federal de Goiás. It uses pdflatex to produce the certificates, zip to
    compact them, and mutt to distribute them. The application is composed by the script file 
    (notary.sh), the information lists (list_*.txt), email models (email_*.txt), the certificate
    models (model_*.tex), and the certificate background image (background.png).

## preparing the files and configurations

### list files
During the event, you must prepare the lists files, which are TAB separated text files with 
information on participants, speakers, monitors, etc. All files have the same structure and the 
columns are identified as follow:
  
  |Column|Variable|Description|
  |---|---|---|
  |1|ID|Participant number| 
  |2|name|
  |3|email|
  |4|hours|certificate workload|
  |5|title|title of poster,presentation or lecture|
  |6|authors|name of all authors of poster/presentation|
  |7|model|type of work: poster or presentation|
  |8|category|in case of prize, category of competition|
  |9|course1|workshop 1 attended/given by the participant|
  |10|c1hours|workload of workshop 1|
  |11|course2|workshop 2 attended/given by the participant|
  |12|c2hours|workload of workshop 2|


If some information present in these columns is not applicable to the event, leave it blank, but 
respect the TAB structure. As a suggestion, you can create and manage the list in some sheet 
application, and copy-past in list file.
    
### background
Create image with art and signatures for the certificate. pdflatex will input the text of 
certificates, based in model files. If necessary, change latex configurations to produce the 
document properly.
  
### certificate models
Edit model_*.tex files to produce certificates text. Attention to the variables used by 
notary.sh: varNOME, varHORAS, varCURSO, varAUTORES, varTITULO, varCATEGORIA, varMODALIDADE.
  
### email models
Edit the text of the email that will be send with the certificates.

## configuring mutt
The email that will send the certificates must be configured to allow IMAP access.
  
In gmail, go click the gear icon, go to Settings, go to the tab Forwarding POP/IMAP, and click the 
Configuration instructions link in IMAP Access row. Then click I want to enable IMAP. At the bottom 
of the page, under the paragraph about configuring your mail client, select Other. Note the mail 
server information and use that information for further settings as shown in the next section. 
Before proceeding further visit https://www.google.com/settings/security/lesssecureapps and 
checkTurn on radio button.
  
The email composition will be done by using mutt: a command line client. Edit/create the file 
.muttrc to set configuration. Here is an example:
   > set realname = "Event name"
   > 
   > set from = "eventname@email.com"
   > 
   > set use_from = yes
   > 
   > set envelope_from = yes
   > 
   > set smtp_url = "smtps://eventname@email.com@smtp.gmail.com:465/"
   > 
   > set smtp_pass = "password"
   > 
   > set imap_user = "escola.de.fisica.ufg@gmail.com"
   > 
   > set imap_pass = "password"
   > 
   > set folder = "imaps://imap.gmail.com:993"
   > 
   > set spoolfile = "+INBOX"
   > 
   > set ssl_force_tls = yes
 
## editing the file script
The notary.sh script can be adapted depending on the event characteristics. However, there are at
least one section to be modified. The first function of the script, named "envio", produce the zip
files and send them using mutt. So, if you want to produce the certificates, but do not send them,
you must comment the line:
   > mutt -s "Email title" $email < $DIR/email_$modelo.txt -a /tmp/certificados_$ID.zip
On the other hand, if you want to send the certificates, you must edit the "Email title".
  
## running the script
Remember of change notary.sh permission. Run it as usual:
   > ./notary.sh

## copyleft
   NOTARY is distribute under MIT license. See COPYING.txt.

## author
    carriunix (carriunix@gmail.com)
