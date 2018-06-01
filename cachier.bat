@Echo off
echo here I am
chcp 1253 

sleep 1
echo.
echo.

CD c:\hsqldb-2.2.8\hsqldb\lib\

REM ======================================================================================
REM USER CHECK


cocolor   E0 "                                                   				"07
echo.
cocolor         E0 "			       PROSOXH!!				     " 07
echo.
cocolor    E0 "                                                   				"07



REM echo aftes oi paraggelies kataxwrithikan sth vardia sou KAI DEN EINAI PHOTOS/CD OK!
echo αυτές οι παραγγελίες καταχωρήθηκαν στη βάρδια σου και ΔΕΝ ΕΙΝΑΙ PHOTOS/CD OK!
echo. 
REM echo tsekare tous FUJI FAKELOUS pou afhneis ston epomeno.....
echo τσέκαρε τους FUJI φακέλους που αφήνεις στον επόμενο

java -jar sqltool.jar --autoCommit --sql="SELECT ID, ORKODATE, TIMEST FROM ORDERSNEW WHERE DATE = TODAY AND NOT (PHOTOSCDOK = TRUE);" sa

echo. 

pause




REM echo afta ta ESODA katagrafhkan sth vardia sou....
echo αυτά τα ΕΣΟΔΑ καταγράφηκαν στη βάρδια σου...
echo.

java -jar sqltool.jar --autoCommit --sql="SELECT ORDERID, TRANSACTIONID, AMOUNT, TIMEST FROM TAMEION WHERE DATE = TODAY and AMOUNT > 0;" sa

echo.
echo.
echo.


REM echo an DEN EINAI swsta kleise kai diorthose afto pou exeis entopisei sth vash...
echo αν ΔΕΝ είναι σωστά κλείσε και διόρθωσε αυτό που έχεις εντοπίσει στη βάση...

REM echo an EINAI swsta, synexise...
echo αν ΕΙΝΑΙ σωστά, συνέχισε...
echo.
cocolor    E0 "                                                   				" 07
pause


echo.
echo.
echo ========================================================
echo.

REM echo afta ta EXODA katagrafhkan sth vardia sou....
echo αυτά τα ΕΞΟΔΑ καταγράφηκαν στη βάρδια σου

java -jar sqltool.jar --autoCommit --sql="SELECT ORDERID, TRANSACTIONID, AMOUNT, TIMEST FROM TAMEION WHERE DATE = TODAY and AMOUNT < 0;" sa


echo.
echo.
echo.

REM echo an DEN EINAI swsta kleise kai diorthose afto pou exeis entopisei sth vash...
echo αν ΔΕΝ είναι σωστά κλείσε και διόρθωσε αυτό που έχεις εντοπίσει στη βάση...

REM echo an EINAI swsta, synexise...
echo αν ΕΙΝΑΙ σωστά, συνέχισε...

echo.
cocolor    E0 "                                                   				" 07
pause

echo         ΠΡΟΣΟΧΗ !!
cocolor    E0                           07
echo.
cocolor         E0 "			       ΠΡΟΣΟΧΗ!!       						" 07  

cocolor  E0 "     Από δω και πέρα ΔΕΝ μπορούμε να κλείσουμε το μαύρο κουτί!!" 07
echo.


echo.
echo.
echo.

cocolor  EC " ΟΤΑΝ ΤΕΛΕΙΩΣΕΙΣ ΜΕ ΤΟ EXCEL, ΠΑΤΑ  --SAVE--  ΚΑΙ ΚΛΕΙΣΕ ΤΟ EXCEL!!" 07

pause
echo.
echo.
echo.
echo.

cocolor  EC " ΟΤΑΝ ΤΕΛΕΙΩΣΕΙΣ ΜΕ ΤΟ EXCEL, ΠΑΤΑ  --SAVE--  ΚΑΙ ΚΛΕΙΣΕ ΤΟ EXCEL!!" 07


echo.
echo.

pause    





REM ======================================================================================
REM record the TRANSACTIONID 

java -jar sqltool.jar --autoCommit --sql="INSERT INTO CACHIER (ID, TIMEST, ESODAMAXID, EXODAMAXID) VALUES ((SELECT MAX(ID) FROM CACHIER)+1,(LOCALTIMESTAMP),(SELECT MAX(TRANSACTIONID) FROM (SELECT TRANSACTIONID, AMOUNT FROM TAMEION WHERE DATE = TODAY AND AMOUNT > 0)),(SELECT MAX(TRANSACTIONID) FROM (SELECT TRANSACTIONID, AMOUNT FROM TAMEION WHERE DATE = TODAY AND AMOUNT < 0)));" sa
echo on
echo.
echo.

echo RECORDED MAX TRANSACTIONIDs  --- καταχωρήθηκαν τα στοιχεία πρωινού
@echo off


REM ======================================================================================
REM  EXTRACT VALUES


java -jar sqltool.jar --autoCommit --sql="SELECT AMOUNT FROM TAMEION WHERE DATE = TODAY and AMOUNT > 0;" sa  | csvfix read_dsv | csvfix echo -smq -osep ; | csvfix echo -smq > c:\cashier\esoda.csv
REM  ====    java -jar sqltool.jar --autoCommit --sql="SELECT TRANSACTIONID FROM TAMEION WHERE DATE = TODAY and AMOUNT > 0;" sa  | csvfix read_dsv | csvfix echo -smq -osep ; | csvfix echo -smq > c:\cashier\transplus.csv

REM =================================
REM TRANSACTIONID VALUES
java -jar sqltool.jar --autoCommit --sql="SELECT TRANSACTIONID FROM TAMEION WHERE DATE = TODAY and AMOUNT > 0;" sa | csvfix read_dsv | csvfix echo -smq -osep ; | csvfix echo -smq >  c:\cashier\transact-in.csv




                                                                                                                                       
java -jar sqltool.jar --autoCommit --sql="SELECT AMOUNT FROM TAMEION WHERE DATE = TODAY and AMOUNT < 0;" sa  | csvfix read_dsv | csvfix echo -smq -osep ; | csvfix echo -smq > c:\cashier\exoda.csv

REM =================================
REM TRANSACTIONID VALUES

java -jar sqltool.jar --autoCommit --sql="SELECT TRANSACTIONID FROM TAMEION WHERE DATE = TODAY and AMOUNT < 0;" sa | csvfix read_dsv | csvfix echo -smq -osep ; | csvfix echo -smq > c:\cashier\transact-out.csv


echo on
echo esoda  / exoda  EXTRACTED...
@echo off

REM ======================================================================================
REM   GENERATE COMPOUND CSV FILES


REM REM paste c:\cashier\esoda.csv c:\cashier\exoda.csv | sed "s/\./,/g" | NCLIP read
paste c:\cashier\esoda.csv c:\cashier\exoda.csv | csvfix read_dsv -s \t -osep @ | sed "s/\./,/g" > c:\cashier\esodaexoda.csv
REM paste c:\cashier\transplus.csv c:\cashier\transminus.csv | csvfix read_dsv -s \t -osep @ | csvfix echo -smq  TRANSPLUSMINUS.CSV


paste c:\cashier\transact-in.csv c:\cashier\transact-out.csv | csvfix read_dsv -s \t -osep @ | sed "s/\./,/g" > c:\cashier\transinout.csv



echo. 
echo     DATA   GENERATED......

pause

REM ======================================================================================
REM create the variables and file to send


cd c:\cashier



gnudate +"TAMEION--%%y-%%m-%%d--%%H.%%M" >   TMPcurrentdate 
set /p  datevar=<TMPcurrentdate                             


echo %datevar%

copy c:\cashier\tameion.ods c:\cashier\tameion-%datevar%.ods



REM =====================================================================================
REM  open and save the tameion-%datevar%.ods


cd "c:\Program Files (x86)\LibreOffice 3.4\program\"    
echo .                                            
echo .                                            


 
echo now...?
soffice.exe file:///c:/cashier/tameion-%datevar%.ods


pause

REM ======================================================================================
REM generate the html report

echo on

echo about to generate report ..
sleep 1

cd \
cd hsqldb-2.2.8\hsqldb\lib
java -jar sqltool.jar --autoCommit sa c:\cashier\htmlreport.sql

pause
echo off
cd \
cd cashier

rename c:\cashier\%datevar% report-%datevar%.html

pause






REM ======================================================================================
REM LOCAL JOBS DONE!   SEND THE RESULTS TO cashier


pause
echo.

echo.
echo.

echo.

echo.
echo 				

echo       =============== SEND E-MAIL ===================
pause
echo.
echo.
echo.

echo.
sleep 1

echo on



REM blat -p gmailsmtp -to fotomadapays@gmail.com -subject tameion-%datevar% -body "tameion_tou_prwinou" -attach tameion-%datevar%.ods -attach report-%datevar%.html -server 127.0.0.1:1109




@echo off
REM fotomadapays@gmail.com
REM ======================================================================================
REM    CLEANUP
@echo off

echo ==================   cleaning up the mess....     ==========================

echo                             bye...

sleep 2

pause
copy tameion-%datevar%.ods tameion.ods

REM =====================================================================================
REM  open and save the tameion.ods


cd "c:\Program Files (x86)\LibreOffice 3.4\program\"    
echo .                                            
echo .                                            
echo 	        	finished....


pause
 

soffice.exe  -headless "macro:///Standard.Module1.ClearDefinedRangeEsodaExoda file:///c:/cashier/tameion.ods

REM
rem del  tameion-%datevar%.ods
rem del  report-%datevar%.html

pause

del  TMPcurrentdate
sleep 1