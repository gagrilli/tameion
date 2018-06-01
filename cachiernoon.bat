@Echo off
echo here I am
chcp 1253 

sleep 1
echo.
echo.

CD c:\hsqldb-2.2.8\hsqldb\lib\

REM ======================================================================================
REM USER CHECK

cocolor    EC "                                                   " 07
echo.
cocolor EC "          PROSOXH!!                  "
echo.
cocolor    EC "                                                   " 07



echo αυτές οι παραγγελίες καταχωρήθηκαν στη βάρδια σου και ΔΕΝ ΕΙΝΑΙ PHIOTOS/CD OK!

ECHO.

echo. 

echo ΤΣΕΚΑΡΕ τους FUJI ΦΑΚΕΛΟΥΣ που αφήνεις στον επόμενο...
echo.
echo.


java -jar sqltool.jar --autoCommit --sql="SELECT DISTINCT ID, ORKOMOSIA, ORKODATE AS ORKODATE, TIMEST AS TIMESTAMP FROM ORDERSNEW, TAMEION WHERE NOT (ORKODATE IS NULL) AND DATE = TODAY AND NOT (PHOTOSCDOK = TRUE) AND (TRANSACTIONID > (SELECT MAX(ESODAMAXID) FROM CACHIER) OR TRANSACTIONID > (SELECT MAX(EXODAMAXID) FROM CACHIER));" sa

echo. 

pause







echo αυτά τα ΕΣΟΔΑ καταγράφηκαν στη βάρδια σου...
echo.

java -jar sqltool.jar --autoCommit --sql="SELECT ORDERID, TRANSACTIONID, AMOUNT, TIMEST FROM TAMEION WHERE DATE = TODAY and AMOUNT > 0  AND TRANSACTIONID > (SELECT ESODAMAXID FROM CACHIER WHERE ID = (SELECT MAX(ID) FROM CACHIER));" sa

echo.
echo.
echo.



echo     αν ΔΕΝ ΕΙΝΑΙ σωστά κλείσε και διόρθωσε αυτό που έχεις εντοπίσει, στη βάση

echo	 αν ΕΙΝΑΙ σωστά, συνέχισε...
echo.
cocolor    EC "                                                   " 07
pause

echo.
echo.
echo =========================================================
echo.


echo αυτά τα ΕΞΟΔΑ καταγράφηκαν στη βάρδια σου....

java -jar sqltool.jar --autoCommit --sql="SELECT ORDERID, TRANSACTIONID, AMOUNT, TIMEST FROM TAMEION WHERE DATE = TODAY and AMOUNT < 0 AND   TRANSACTIONID > (SELECT EXODAMAXID FROM CACHIER WHERE ID = (SELECT MAX(ID) FROM CACHIER));" sa


echo.
echo.
echo.


echo     αν ΔΕΝ ΕΙΝΑΙ σωστά κλείσε και διόρθωσε αυτό που έχεις εντοπίσει, στη βάση

echo	 αν ΕΙΝΑΙ σωστά, συνέχισε...
echo.
cocolor    EC "                                                   " 07

@Echo off

echo.
pause


cocolor    EC "                                                   " 07
echo.
cocolor EC "          ΠΡΟΣΟΧΗ!!                  "
echo.
cocolor  EC " ΑΠΟ ΔΩ ΚΑΙ ΠΕΡΑ ΔΕΝ ΚΛΕΙΝΟΥΜΕ ΤΟ ΜΑΥΡΟ ΚΟΥΤΙ !! " 07

echo.
echo.
echo.

cocolor  EC " ΟΤΑΝ ΤΕΛΕΙΩΣΕΙΣ ΜΕ ΤΟ EXCEL, ΠΑΤΑ --SAVE-- ΚΑΙ ΚΛΕΙΣΕ ΤΟ EXCEL!!" 07

pause
echo.
echo.
echo.
echo.


cocolor  EC " ΟΤΑΝ ΤΕΛΕΙΩΣΕΙΣ ΜΕ ΤΟ EXCEL, ΠΑΤΑ --SAVE-- ΚΑΙ ΚΛΕΙΣΕ ΤΟ EXCEL!!" 07

echo.
echo.

pause

REM ======================================================================================
REM  EXTRACT VALUES


                                                                                                                                       

java -jar sqltool.jar --autoCommit --sql="SELECT AMOUNT FROM TAMEION WHERE DATE = TODAY and AMOUNT > 0 AND TRANSACTIONID > (SELECT ESODAMAXID FROM CACHIER WHERE ID = (SELECT MAX(ID) FROM CACHIER));"  sa  | csvfix read_dsv | csvfix echo -smq -osep ; | csvfix echo -smq > c:\cashier\esodanoon.csv

echo 11



REM =================================
REM TRANSACTIONID VALUES
java -jar sqltool.jar --autoCommit --sql="SELECT TRANSACTIONID FROM TAMEION WHERE DATE = TODAY and AMOUNT > 0  AND   TRANSACTIONID > (SELECT ESODAMAXID FROM CACHIER WHERE ID = (SELECT MAX(ID) FROM CACHIER));" sa | csvfix read_dsv | csvfix echo -smq -osep ; | csvfix echo -smq >  c:\cashier\transact-in.csv


echo .
echo 11

pause

java -jar sqltool.jar --autoCommit --sql=" SELECT AMOUNT FROM TAMEION WHERE DATE = TODAY and AMOUNT < 0 AND   TRANSACTIONID > (SELECT EXODAMAXID FROM CACHIER WHERE ID = (SELECT MAX(ID) FROM CACHIER));"  sa  | csvfix read_dsv | csvfix echo -smq -osep ; | csvfix echo -smq >  c:\cashier\exodanoon.csv

echo.

REM =================================
REM TRANSACTIONID VALUES
java -jar sqltool.jar --autoCommit --sql="SELECT TRANSACTIONID FROM TAMEION WHERE DATE = TODAY and AMOUNT < 0 AND   TRANSACTIONID > (SELECT EXODAMAXID FROM CACHIER WHERE ID = (SELECT MAX(ID) FROM CACHIER));" sa | csvfix read_dsv | csvfix echo -smq -osep ; | csvfix echo -smq > c:\cashier\transact-out.csv


echo 	έσοδα  / έξοδα  EXTRACTED...

echo.
echo.
echo.


REM ======================================================================================
REM   GENERATE COMPOUND CSV FILES


REM REM  paste c:\cashier\esodanoon.csv c:\cashier\exodanoon.csv | sed "s/\./,/g" | NCLIP read
paste c:\cashier\esodanoon.csv c:\cashier\exodanoon.csv | csvfix read_dsv -s \t -osep @ | sed "s/\./,/g" > c:\cashier\esodaexoda.csv


paste c:\cashier\transact-in.csv c:\cashier\transact-out.csv | csvfix read_dsv -s \t -osep @ | sed "s/\./,/g" > c:\cashier\transinout.csv



REM ======================================================================================
REM create the variables and file to send


cd \
cd c:\cashier



gnudate +"TAMEION--%%y-%%m-%%d--%%H.%%M" >   TMPcurrentdate 


echo EDIT.....
pause
set /p  datevar=<TMPcurrentdate                             


echo						 %datevar%
echo.
echo.

echo 11
pause

@echo off
copy c:\cashier\tameion.ods c:\cashier\tameion-%datevar%.ods



REM =====================================================================================
REM  open and save the tameion-%datevar%.ods



cd "c:\Program Files (x86)\LibreOffice 3.4\program\"

echo 

 
echo 									now...?
soffice.exe file:///c:/cashier/tameion-%datevar%.ods



REM ======================================================================================
REM generate the html report

echo. 
echo 				about to generate report ..
pause

cd \
cd hsqldb-2.2.8\hsqldb\lib
java -jar sqltool.jar --autoCommit sa c:\cashier\htmlreport.sql

echo .
echo report generated ...

pause

echo off
cd \
cd cashier

rename c:\cashier\%datevar% report-%datevar%.html



REM ======================================================================================
REM LOCAL JOBS DONE!   SEND THE RESULTS TO cashier



echo.

echo.
echo.

echo.

echo.
echo 				

echo       =============== SEND E-MAIL ===================

echo.
echo.
pause
echo.

echo.

sleep 1

echo on




REM blat -p gmailsmtp -to fotomadapays@gmail.com -subject tameion-%datevar% -body "tameion_ths_vardias_gia_vrady" -attach tameion-%datevar%.ods -attach report-%datevar%.html -server 127.0.0.1:1109
REM fotomadapays@gmail.com
 


REM ======================================================================================
REM    CLEANUP


echo ==================           cleaning up the mess....     ==========================
sleep 1
echo                                μπάι...
@echo off
sleep 2


copy c:\cashier\tameion-%datevar%.ods c:\cashier\tameion.ods

REM  open and save the tameion.ods


cd "c:\Program Files (x86)\LibreOffice 3.4\program\"    
echo .                                            
echo .                                            
echo 	        	finished....
 

soffice.exe  -headless "macro:///Standard.Module1.CleardefinedRangeEsodaExoda file:///c:/cashier/tameion.ods

REM

del  TMPcurrentdate
REM del  tameion-%datevar%.ods
REM del  report-%datevar%.html
