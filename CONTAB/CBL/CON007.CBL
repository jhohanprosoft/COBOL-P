000002 IDENTIFICATION DIVISION.
000003 PROGRAM-ID. CON007.
000007*   CONTABILIDAD - BUSCA EL ULTIMO NUMERO DE UNA SECUENCIA.
000008 ENVIRONMENT     DIVISION.
000009 INPUT-OUTPUT SECTION.
000010 FILE-CONTROL. 
000024     SELECT ARCHIVO-LOTES LOCK MODE IS AUTOMATIC
000025	          ASSIGN NOM-LOTE-LNK
000026            ORGANIZATION IS INDEXED;
000027            ACCESS MODE  IS DYNAMIC
000028            RECORD KEY   IS COD-LOTE
000029            ALTERNATE RECORD KEY IS NOMBRE-LOTE WITH DUPLICATES
000030            FILE STATUS IS OTR-STAT.
000031 COPY "P:\PROG\PROYECT\FUENTES\FS-MOVIM.CBL".
000032
000044 DATA DIVISION.
000045 FILE SECTION.
000046 COPY "P:\PROG\PROYECT\FUENTES\FD-LOTES.CBL".
000050 COPY "P:\PROG\PROYECT\FUENTES\FD-MOVIM.CBL".
000051
000052 WORKING-STORAGE SECTION.
000053 COPY "P:\PROG\PROYECT\FUENTES\WEB-CARAC.CBL".
000054
000055 
000056 77 COMP-ANT                              PIC 9(6).
000065 77 NRO-ULT-COMP-W                        PIC 9(6).
000066 77 SW9                                   PIC 9.
000067 77 SEC-W                                 PIC X(50).
000068 77 ULT-NRO-W                             PIC 9(9).
000069 01 DIR-CAJ-W                             PIC X(30).
000070
000071 01 SECUENC-EDIT.
000072    02 SEC1-EDIT                          PIC 9.
000073    02 SEC2-EDIT                          PIC XX.
000079
000086 LINKAGE SECTION.
000087 01 NOMBRE-LNK               PIC X(30).
000088 01 DIRECTORIO-W             PIC X(30).
000089 01 INVALID-007              PIC X(80).
000090 01 DATO-ULT-MOV-LNK.
000091    02 LOTE-ULT-MOV-LNK.
000092       03 LOTE1-ULT-MOV-LNK  PIC X.
000093       03 LOTE2-ULT-MOV-LNK  PIC X.
000094    02 NRO-ULT-COMP-LNK.
000095       03 NRO1-ULT-COMP-LNK  PIC 9(3).
000096       03 NRO2-ULT-COMP-LNK  PIC 9(6).
000097    02 FECHA-ULT-MOV-LNK.
000098       03 ANO-ULT-MOV-LNK    PIC 99.
000099       03 MES-ULT-MOV-LNK    PIC 99.
000100       03 DIA-ULT-MOV-LNK    PIC 99.
000101
000102 PROCEDURE DIVISION USING DATO-ULT-MOV-LNK DIRECTORIO-W NOMBRE-LNK INVALID-007.
000103
000104 DECLARATIVES.                    
000117 I-O-TEST SECTION.
000118     USE AFTER EXCEPTION PROCEDURE ON MOVIMIENTO-DIARIO.
000119 ESCR-EXCEPTIONES.
000120     IF OTR-STAT = "00" OR "35"             
000121        CONTINUE
000122     ELSE
000123        MOVE OTR-STAT TO INVALID-007       
000124        GO TO SALIR.
000127
000128 I-O-TEST SECTION.
000129     USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-LOTES.         
000130 ESCR-EXCEPTIONES.
000131     IF OTR-STAT = "00" 
000132        CONTINUE 
000133     ELSE
000134        MOVE OTR-STAT TO INVALID-007       
000135        GO TO SALIR   
000136     END-IF.
000139
000140 END DECLARATIVES.
000141 PROCEDURAL SECTION.
000151
000152 ASIGNAR-NOMBRE.
000160     MOVE NOMBRE-LNK TO NOM-LOTE-LNK
000165     INSPECT NOM-LOTE-LNK   REPLACING FIRST "                           "
000166                                         BY "\PROG\DATOS\SC-ARCHLOTE.DAT".
000167
000168     OPEN INPUT ARCHIVO-LOTES
000169     MOVE LOTE-ULT-MOV-LNK   TO COD-LOTE
000170     READ ARCHIVO-LOTES WITH NO LOCK
000171          INVALID KEY
000172            IF LOTE2-ULT-MOV-LNK = "Q"
000173               MOVE 0 TO CONSEC-LOTE
000174            ELSE
000175               MOVE 1 TO CONSEC-LOTE 
000176            END-IF
000177     END-READ
000178     CLOSE ARCHIVO-LOTES.
000179
000180     MOVE DIRECTORIO-W TO DIR-CAJ-W.
000181     INSPECT DIR-CAJ-W REPLACING FIRST "\ENE "  BY    "     ".
000182     INSPECT DIR-CAJ-W REPLACING FIRST "\FEB "  BY    "     ".
000183     INSPECT DIR-CAJ-W REPLACING FIRST "\MAR "  BY    "     ".
000184     INSPECT DIR-CAJ-W REPLACING FIRST "\ABR "  BY    "     ".
000185     INSPECT DIR-CAJ-W REPLACING FIRST "\MAY "  BY    "     ".
000186     INSPECT DIR-CAJ-W REPLACING FIRST "\JUN "  BY    "     ".
000187     INSPECT DIR-CAJ-W REPLACING FIRST "\JUL "  BY    "     ".
000188     INSPECT DIR-CAJ-W REPLACING FIRST "\AGT "  BY    "     ".
000189     INSPECT DIR-CAJ-W REPLACING FIRST "\SEP "  BY    "     ".
000190     INSPECT DIR-CAJ-W REPLACING FIRST "\OCT "  BY    "     ".
000191     INSPECT DIR-CAJ-W REPLACING FIRST "\NOV "  BY    "     ".
000192     INSPECT DIR-CAJ-W REPLACING FIRST "\DIC "  BY    "     ".
000193     INSPECT DIR-CAJ-W REPLACING FIRST "\CIE "  BY    "     ".
000194
000195     MOVE NOMBRE-LNK TO NOM-MOV
000201     IF CONSEC-LOTE = 1
000202        INSPECT NOM-MOV REPLACING FIRST "                              "
000203                                     BY DIR-CAJ-W
000204        INSPECT NOM-MOV REPLACING FIRST "                       "
000205                                     BY "\CONTROL\SC-ARCHMOV.DAT"
000207     ELSE
000208        INSPECT NOM-MOV REPLACING FIRST "                              "
000209                                     BY DIRECTORIO-W
000210        INSPECT NOM-MOV REPLACING FIRST "               "
000211                                     BY "\SC-ARCHMOV.DAT"
000213     END-IF.
000214
000215 ABRIR-MOVIMIENTO.
000216     OPEN INPUT MOVIMIENTO-DIARIO.
000217
000218     EVALUATE OTR-STAT
000219        WHEN "00"  GO TO LEER-NUMERACION
000220        WHEN "35"  OPEN OUTPUT MOVIMIENTO-DIARIO
000221                   CLOSE       MOVIMIENTO-DIARIO
000222                   GO TO ABRIR-MOVIMIENTO
000223        WHEN OTHER GO TO CERRAR-ARCHIVOS
000224     END-EVALUATE.
000225
000226 LEER-NUMERACION.
000227     INITIALIZE MOV-DIARIO.
000228     MOVE "99999999" TO LLAVE-COMP-MOV.
000229     MOVE 0                 TO SEC1-EDIT
000230     MOVE LOTE-ULT-MOV-LNK  TO SEC2-EDIT
000231     MOVE SECUENC-EDIT      TO SECU-MOV.
000232
000233     READ MOVIMIENTO-DIARIO RECORD KEY IS SECUENCIA-MOV
000234          INVALID KEY  CLOSE    MOVIMIENTO-DIARIO
000235                       OPEN I-O MOVIMIENTO-DIARIO
000236                       INITIALIZE ULT-NRO-MOV CONSEC-LTF-MOV 
000237                       MOVE "ULTIMO COMPROBANTE" TO DETALLE-MOV
000238                       WRITE MOV-DIARIO END-WRITE.
000239
000240     IF ULT-NRO-MOV IS NOT NUMERIC
000241        INITIALIZE ULT-NRO-MOV
000242     END-IF.
000243
000244     IF CONSEC-LTF-MOV  IS NOT NUMERIC
000245        INITIALIZE CONSEC-LTF-MOV 
000246     END-IF.
000247
000248     MOVE FECHA-VENCE-MOV  TO FECHA-ULT-MOV-LNK.
000249
000250     IF LOTE2-ULT-MOV-LNK = "Q"
000251        MOVE ULT-NROPQ-MOV TO ULT-NRO-W
000252        ADD  1             TO ULT-NRO-W
000253        MOVE ULT-NRO-W     TO NRO-ULT-COMP-LNK
000254     ELSE
000255        INITIALIZE            NRO-ULT-COMP-LNK
000256        MOVE ULT-NRO-MOV   TO NRO2-ULT-COMP-LNK
000257        ADD  1             TO NRO2-ULT-COMP-LNK
000258     END-IF.
000259
000260     IF LOTE-ULT-MOV-LNK = "LT"
000261        MOVE CONSEC-LTF-MOV TO NRO-ULT-COMP-LNK
000262        ADD  1              TO NRO2-ULT-COMP-LNK
000263     END-IF.
000264
000265 CERRAR-ARCHIVOS.
000266     CLOSE MOVIMIENTO-DIARIO.
000267
000268 SALIR.
000269     EXIT PROGRAM.
000271
