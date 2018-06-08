#!/bin/bash

# initialization

#dateiso is today's date
#lastdate is date of last cachier operation
dateiso = $(date --iso-8601)

lastdate = $(sqltool ...)


java -jar sqltool.jar --autoCommit --sql="SELECT ID, EWPNYMO AS ΕΠΩΝΥΜΟ, ORKODATE, TIMEST FROM ORDERSNEW WHERE DATE = TODAY AND NOT (PHOTOSCDOK = TRUE);" sa > /tmp/fuji

dialog --textbox /tmp/fuji 40 75; clear

dialog --yesno "Είσαι εντάξει με τη λίστα, όπως φαίνεται;;\n \n  Αν όχι, πάτα No για να προσθέσεις εγγραφή και ξανάρχισε" 10 30 ; clear


# do something with the exit code

# case  in

#     0) continue
#     1) break ; exit
#     255) break ; exit

# esac


#* collection

#** πάρε τα έσοδα 
#esoda = $(sqltool SUM(amount) from tameion> 0
	  
esoda = $(java -jar sqltool.jar --autoCommit --sql="SELECT SUM(AMOUNT) FROM TAMEION WHERE DATE = TODAY AND AMOUNT > 0;" sa)


	 
#** παρε τα έξοδα
#sqltool SUM(amount) from tameion < 0
exoda = $(java -jar sqltool.jar --autoCommit --sql="SELECT SUM(AMOUNT) FROM TAMEION WHERE DATE = TODAY AND AMOUNT < 0;" sa)

#########################################################	    

export DSV_COL_DELIM=\t ; java -jar sqltool.jar --autoCommit --sql="SELECT ORDERID, TRANSACTIONID, NAME, AMOUNT, TIMEST, COMMENT FROM TAMEION WHERE DATE = TODAY and AMOUNT > 0;" sa  > /tmp/esodalist

export DSV_COL_DELIM=\t ; java -jar sqltool.jar --autoCommit --sql="SELECT ORDERID, TRANSACTIONID, NAME, AMOUNT, TIMEST, COMMENT FROM TAMEION WHERE DATE = TODAY and AMOUNT < 0;" sa  > /tmp/exodalist





dialog --title "ΠΡΟΣΟΧΗ" --msgbox "θα δεις τα έξοδα και τα έσοδα της βάρδιας σου, όπως τα ξέρει η βάση.\n Αν συμφωνείς, πάτα το EXIT  (με enter), και τέλος, το OK.\n Αν όχι, πάτα το Ctrl-C ή το ESC για να φύγεις και να ξαναρχίσεις" 10 80 dialog --textbox  /tmp/esodalist 60 110 --and-widget --begin 30 14 --textbox  /tmp/exodalist 35 110 --and widget --begin 58 14 --msgbox  "έσοδα: $esoda  έξοδα: $exoda" 5 90


## do something with the exit code


