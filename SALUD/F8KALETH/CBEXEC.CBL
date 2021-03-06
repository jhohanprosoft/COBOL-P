000010 @OPTIONS ALPHAL(WORD)
000020
000030* This is a called program that will launch an application using the Windows
000040*  API call "CreateProcessA".
000050*
000060* There are four parameters that as passed to this subroutine:
000070*
000080* COMMAND-LINE-STRING PIC X(80) - This variable must contain the fully qualified path and 
000090*  								filename of the application to run.
000100*
000110* HOW-TO-SHOW-THE-WINDOW PIC s9(4) COMP-5 - This variable must contain a value of:
000120*												1 = Show the application in a normal window
000130*												2 = Show the application minimized
000140*												3 = Show the application maximized.
000150*
000160* SYNC-ASYNC-FLAG PIC s9(4) COMP-5 - This variable must contain a value of:
000170*										1 = Start the application synchronously (i.e. 
000180*											the calling program is suspended until
000190*											the application (in COMMAND-LINE-STRING) is closed
000200*										0 = Start the application asynchronously (i.e.
000210*											return to the program that called this immediately).
000220*
000230* RETURNED-VALUE PIC s9(9) COMP-5 - This is the return code from the call to CreateProcessA 
000240*										and is used to indicate to the calling program whether
000250*										the application (as specified in COMMAND-LINE-STRING)
000260*										was successfully started. A value of 0 indicates failure. 
000270* 
000280 identification division.
000290 PROGRAM-ID. CBEXEC.
000300 AUTHOR. T ERIN KELLEY 7/6/99.
000310 ENVIRONMENT DIVISION.
000320 DATA DIVISION.
000330 WORKING-STORAGE SECTION.
000340 01  DWCREATIONFLAGS             PIC S9(9) COMP-5 VALUE 512.
000350 
000360 01  BLNHERITHANDLES             PIC S9(4) COMP-5 VALUE ZERO.
000370 
000380 01  STARTUPINFO.
000390     05  CB                      PIC 9(9) COMP-5.
000400     05  LPRESERVED              POINTER VALUE ZERO.
000410     05  LPDESKTOP               POINTER VALUE ZERO.
000420     05  LPTITLE                 POINTER VALUE ZERO.
000430     05  DWX                     PIC S9(9) COMP-5 VALUE ZERO.
000440     05  DWY                     PIC S9(9) COMP-5 VALUE ZERO.
000450     05  DWXSIZE                 PIC S9(9) COMP-5 VALUE ZERO.
000460     05  DWYSIZE                 PIC S9(9) COMP-5 VALUE ZERO.
000470     05  DWXCOUNTCHARS           PIC S9(9) COMP-5 VALUE ZERO.
000480     05  DWYCOUNTCHARS           PIC S9(9) COMP-5 VALUE ZERO.
000490     05  DWFILLATTRIBUTE         PIC S9(9) COMP-5 VALUE ZERO.
000500     05  DWFLAGS                 PIC S9(9) COMP-5 VALUE 1.
000510     05  WSHOWWINDOW             PIC S9(4) COMP-5 VALUE 1.
000520     05  CBRESERVED2             PIC S9(4) COMP-5 VALUE ZERO.
000530     05  LPRESERVED2             PIC S9(9) COMP-5 VALUE ZERO.
000540     05  HSTDINPUT               PIC S9(9) COMP-5 VALUE ZERO.
000550     05  HSTDOUTPUT              PIC S9(9) COMP-5 VALUE ZERO.
000560     05  HSTDERROR               PIC S9(9) COMP-5 VALUE ZERO.
000570
000580 01  PROCESSINFO.
000590     05  HPROCESS                PIC S9(9) COMP-5 VALUE ZERO.
000600     05  HTHREAD                 PIC S9(9) COMP-5 VALUE ZERO.
000610     05  DWPROCESSID             PIC S9(9) COMP-5 VALUE ZERO.
000620     05  DWTHREADID              PIC S9(9) COMP-5 VALUE ZERO.
000630
000640 01  THE-COMMAND-LINE.
000650     05  COMMAND_LINE_STRING     PIC X(1024) VALUE LOW-VALUES.
000660     05  FILLER                  PIC 9(2) COMP-5 VALUE ZERO.  *> Note, must terminate the command line with zeros
000670
000680 01  INFINITE-WAIT			   PIC S9(9) COMP-5 VALUE -1.      
000690
000700 01  RETURN-VALUE		           PIC S9(9) COMP-5.
000710 
000720 LINKAGE SECTION.
000730 01	COMMAND-LINE-STRING1	   PIC X(80).
000740 01	HOW-TO-SHOW-THE-WINDOW	   PIC S9(4) COMP-5.
000750 01	SYNC-ASYNC-FLAG		   PIC S9(4) COMP-5.
000760 01	RETURNED-VALUE		   PIC s9(9) COMP-5.
000770 
000780 PROCEDURE DIVISION USING COMMAND-LINE-STRING1, HOW-TO-SHOW-THE-WINDOW, SYNC-ASYNC-FLAG, RETURNED-VALUE.
000790 
000800		MOVE COMMAND-LINE-STRING1 TO COMMAND_LINE_STRING
000810		MOVE HOW-TO-SHOW-THE-WINDOW TO WSHOWWINDOW
000820		
000830		COMPUTE CB = FUNCTION LENGTH(STARTUPINFO)
000840		
000850      CALL "CreateProcessA" WITH STDCALL USING
000860                            BY VALUE 0 
000870                            BY REFERENCE THE-COMMAND-LINE
000880                            BY VALUE 0
000890                            BY VALUE 0
000900                            BY VALUE BLNHERITHANDLES
000910                            BY VALUE DWCREATIONFLAGS
000920                            BY VALUE 0
000930                            BY VALUE 0
000940                            BY REFERENCE STARTUPINFO
000950                            BY REFERENCE PROCESSINFO
000960                            RETURNING RETURN-VALUE
000970      END-CALL
000980      
000990      MOVE RETURN-VALUE TO RETURNED-VALUE
001000      
001010    	IF SYNC-ASYNC-FLAG = 0 
001020      	EXIT PROGRAM
001030      END-IF
001040
001050      CALL "WaitForSingleObject" WITH STDCALL USING 
001060      						   BY VALUE HPROCESS
001070      						   BY VALUE INFINITE-WAIT
001080      						   RETURNING RETURN-VALUE
001090      						   
001100		CALL "CloseHandle" WITH STDCALL USING
001110						   BY VALUE HPROCESS       
001120 END PROGRAM CBEXEC.		   
001130
