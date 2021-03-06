004820*=================================================================
004830* CREA ARCHIVO JSON PARA VENTANA CONSULTA DE ARTICULOS
004840*=================================================================
004850 IDENTIFICATION DIVISION.
004860 PROGRAM-ID. "HttpExtensionProc".
004870 ENVIRONMENT DIVISION.
004880 CONFIGURATION SECTION.
004890 INPUT-OUTPUT SECTION.
004900 FILE-CONTROL.
004910     COPY "P:\PROG\PROYECT\FUENTES\FS-USUNET.CBL".
004920     COPY "P:\PROG\PROYECT\FUENTES\FS-SESION.CBL".
004930
000170     SELECT ARCHIVO-USUARIOS LOCK MODE IS AUTOMATIC
000180            ASSIGN NOM-USUAR-W
000190            ORGANIZATION IS INDEXED
000200            ACCESS MODE IS DYNAMIC;
000210            RECORD KEY IS NOMBRE-USU
000220            ALTERNATE RECORD KEY IS CTL-USU     WITH DUPLICATES
000230            ALTERNATE RECORD KEY IS CLAVE-USU   WITH DUPLICATES
000240            ALTERNATE RECORD KEY IS CLAVE-2-USU WITH DUPLICATES
000250            FILE STATUS IS OTR-STAT.


           SELECT MOVIMIENTO-DIARIO LOCK MODE IS AUTOMATIC
                  ASSIGN NOM-MOV-W
                  ORGANIZATION IS INDEXED;
                  ACCESS MODE IS DYNAMIC
                  RECORD KEY IS LLAVE-MOV
                  ALTERNATE RECORD KEY SECUENCIA-MOV
                  ALTERNATE RECORD KEY LLAVE-FEC
                  ALTERNATE RECORD KEY LLAVE-DOC-MOV   WITH DUPLICATES
                  ALTERNATE RECORD KEY COSTO-MOV       WITH DUPLICATES
                  ALTERNATE RECORD KEY NRO-ORD-MOV     WITH DUPLICATES
                  ALTERNATE RECORD KEY LLAVE-LIBRE-MOV WITH DUPLICATES
                  FILE STATUS IS OTR-STAT.

005020
005030     SELECT ARCHIVO-JSON
005040            ASSIGN NOM-PLANO-W
005050            ORGANIZATION IS LINE SEQUENTIAL
005060            FILE STATUS IS OTR-STAT.
005070
005080 DATA DIVISION.
005090 FILE SECTION.
005100 COPY "P:\PROG\PROYECT\FUENTES\FD-USUNET.CBL".
005110 COPY "P:\PROG\PROYECT\FUENTES\FD-SESION.CBL".
000690 COPY "P:\PROG\PROYECT\FUENTES\FD-USUAR.CBL".
       COPY "P:\PROG\PROYECT\FUENTES\FD-MOVIM.CBL".


005140 FD  ARCHIVO-JSON
005150     LABEL RECORD STANDARD.
005160 01  REG-PLANO.
005170     02 DATOS-PLANO     PIC X(500).
005180
005190 WORKING-STORAGE SECTION.
005200 COPY "P:\PROG\PROYECT\FUENTES\COBW3.CBL".
005210 COPY "P:\PROG\PROYECT\FUENTES\WEB-CARAC.CBL".

       77 NOM-PLANO-W               PIC X(90).
       77 NOM-USUAR-W               PIC X(70).
       77 NOM-MOV-W                 PIC X(70).

       01  ALMACEN-W.
           02 ALM1-W                PIC X(3).
           02 ALM2-W                PIC 99.

005260
001067 77  SUC-TMP                   PIC X.
005230 77  SW-VAR                    PIC 9.
005240 77  K                         PIC 99.
001252 77  MES-SAL-W                 PIC X(4).
001240 77  TAR-W                     PIC 99V9.
001250 77  VALOR-VENTA               PIC 9(12).
001251 77  IVA-TMP                   PIC 9(12).
001253 77  EXISTENCIAS-TMP           PIC S9(12)V99.
       77  NRO-EDIT                  PIC ZZZZZZZZZZZZ.
       77  PROCENTAJE-EDIT           PIC ZZ.Z.
       77  SW-USO                    PIC XX.
       77  VALOR-MOV-EDIT            PIC Z(12).ZZ-.



       01 LINEA-LLEGAD-W             PIC X(100).

       01 DATO-LLEGADA-W.
          02 SESION-LLEGAD-W        PIC X(29).
          02 DIRECTORIO-LLEGAD-W    PIC X(30).
          02 CARPTA-LLEGAD-W        PIC X(9).
          02 ISLAS-W                PIC X.
          02 REGISTRADORA-W         PIC X.


       01 LIN-1.
          02 FILLER                  PIC X(9)   VALUE "{*LLAVE*:".
          02 FILLER                  PIC X      VALUE "*".
          02 LLAVE-J                 PIC X(45).
          02 FILLER                  PIC XX     VALUE "*,".
          02 FILLER                  PIC X(6)   VALUE "*LOT*:".
          02 FILLER                  PIC X      VALUE "*".
          02 LOT-J                   PIC XX.
          02 FILLER                  PIC XX     VALUE "*,".
          02 FILLER                  PIC X(8)   VALUE "*COMPR*:".
          02 FILLER                  PIC X      VALUE "*".
          02 COMPR-J                 PIC X(6).
          02 FILLER                  PIC XX     VALUE "*,".
          02 FILLER                  PIC X(6)   VALUE "*SEC*:".
          02 FILLER                  PIC X      VALUE "*".
          02 SEC-J                   PIC X(3).
          02 FILLER                  PIC XX     VALUE "*,".
          02 FILLER                  PIC X(8)   VALUE "*REFER*:".
          02 FILLER                  PIC X      VALUE "*".
          02 REFER-J                 PIC X(6).
          02 FILLER                  PIC XX     VALUE "*,".
          02 FILLER                  PIC X(8)   VALUE "*VALOR*:".
          02 FILLER                  PIC X      VALUE "*".
          02 VALOR-J                 PIC X(16).
          02 FILLER                  PIC XX     VALUE "*,".
          02 FILLER                  PIC X(8)   VALUE "*ULT-N*:".
          02 FILLER                  PIC X      VALUE "*".
          02 ULT-NRO-MOV-J           PIC X(6).
          02 FILLER                  PIC XX     VALUE "*,".
          02 FILLER                  PIC X(8)   VALUE "*FECHA*:".
          02 FILLER                  PIC X      VALUE "*".
          02 FECHA-MOV-J             PIC X(6).
003710    02 FILLER                  PIC XX     VALUE "*}".
005040    02 CIERRE-LIN-1            PIC X.



006310 LINKAGE SECTION.
006320 COPY "P:\PROG\PROYECT\FUENTES\ISAPICTX.CBL".
006330 PROCEDURE DIVISION WITH stdcall LINKAGE USING ISAPI-CTX-CNT.
006340
006350 DECLARATIVES.
002570 I-O-TEST SECTION.
002580     USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-USUARIOS.         
002590 ESCR-EXCEPTIONES.
002600     IF OTR-STAT = "00" 
002610        CONTINUE 
002620     ELSE
002630        MOVE OTR-STAT         TO MENSAJE1-HTML
002640        MOVE NOM-USUAR-W      TO MENSAJE2-HTML
002650        MOVE "INV803"         TO MENSAJE3-HTML
002660        GO TO MOSTRAR-ERROR
002670     END-IF.

006360 I-O-TEST SECTION.
006370     USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-USUNET.         
006380 ESCR-EXCEPTIONES.
006390     IF OTR-STAT = "00"
006400        CONTINUE 
006410     ELSE
006420        MOVE OTR-STAT         TO MENSAJE1-HTML
006430        MOVE NOM-USU-W        TO MENSAJE2-HTML
006440        MOVE "INV803"         TO MENSAJE3-HTML
006450        GO TO ENVIAR-ERROR
006460     END-IF.
006470
006480 I-O-TEST SECTION.
006490     USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-SESION.
006500 ESCR-EXCEPTIONES.
006510     IF OTR-STAT = "00" 
006520        CONTINUE 
006530     ELSE
006540        MOVE OTR-STAT         TO MENSAJE1-HTML
006550        MOVE NOM-SESION-W     TO MENSAJE2-HTML
006560        MOVE "INV803"         TO MENSAJE3-HTML
006570        GO TO ENVIAR-ERROR
006580     END-IF.
006590  
006600 I-O-TEST SECTION.
006610     USE AFTER EXCEPTION PROCEDURE ON MOVIMIENTO-DIARIO.
006620 ESCR-EXCEPTIONES.
006630     IF OTR-STAT = "00"
006640        CONTINUE 
006650     ELSE
006660        MOVE OTR-STAT         TO MENSAJE1-HTML
006670        MOVE NOM-MOV-W        TO MENSAJE2-HTML
006680        MOVE "INV803"         TO MENSAJE3-HTML
006690        GO TO ENVIAR-ERROR
006700     END-IF.
006590  
006600 I-O-TEST SECTION.
006610     USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-JSON.
006620 ESCR-EXCEPTIONES.
006630     IF OTR-STAT = "00" OR "35"
006640        CONTINUE 
006650     ELSE
006660        MOVE OTR-STAT         TO MENSAJE1-HTML
006670        MOVE NOM-PLANO-W      TO MENSAJE2-HTML
006680        MOVE "INV803"         TO MENSAJE3-HTML
006690        GO TO ENVIAR-ERROR
006700     END-IF.
006710
006720  END DECLARATIVES.
006730
006740 INICIAR-IIS.
006750     MOVE LOW-VALUE TO COBW3.
006760     MOVE FUNCTION ADDR(ISAPI-CTX-CNT) TO COBW3-CONTEXT.
006770     CALL "COBW3_INIT" USING COBW3.
006780
006790 LEER-DATO-HTML.
006800     MOVE "datosh" TO COBW3-SEARCH-DATA.
006810     CALL "COBW3_GET_VALUE" USING COBW3.
001854     MOVE COBW3-GET-DATA    TO LINEA-LLEGAD-W.

           INITIALIZE DATO-LLEGADA-W

           UNSTRING LINEA-LLEGAD-W DELIMITED BY "|"
              INTO SESION-LLEGAD-W, DIRECTORIO-LLEGAD-W, CARPTA-LLEGAD-W, ISLAS-W, REGISTRADORA-W
           END-UNSTRING.



001855     MOVE SESION-LLEGAD-W    TO LLAVE-SESION-W.
           MOVE FUNCTION CURRENT-DATE TO FECHA-TOTAL.
000830     ACCEPT HORA-TOTAL FROM TIME.

          
000797 INICIAR-SESION.
000806     MOVE "D:\WEB\MAIN-ELECT\DATOS\SC-SESION.DAT" TO NOM-SESION-W
000810     GO TO VALIDAR-SESION.
000850
000860 FIN-VALIDAR-SESION.
006840     
006900 ABRIR-USUARIO.
006910     INITIALIZE OTR-STAT.
006920     MOVE "D:\WEB\MAIN-ELECT\DATOS\SC-ARCHUSU.DAT" TO NOM-USU-W
006930
006940     OPEN INPUT ARCHIVO-USUNET
006950     EVALUATE OTR-STAT
006960       WHEN "00"  CONTINUE
006970       WHEN "35"  OPEN OUTPUT ARCHIVO-USUNET
006980                  INITIALIZE REG-USUNET
006990                  WRITE REG-USUNET
007000                  CLOSE ARCHIVO-USUNET
007010                  MOVE "Validacion de Usuario"       TO MENSAJE1-HTML
007020                  MOVE "Falta configurar usuarios"   TO MENSAJE2-HTML
007030                  MOVE "Sc"                          TO MENSAJE3-HTML
007040                  GO TO ENVIAR-ERROR
007050       WHEN OTHER GO TO CERRAR-SESION
007060     END-EVALUATE.
007070
007080     INITIALIZE LLAVE-USUNET.

007110 LEER-USUARIO.
007120     READ ARCHIVO-USUNET NEXT AT END MOVE 0 TO SW-FIN.
007130
007140     CLOSE ARCHIVO-USUNET.
007200     
007210     IF NOMBRE-USUNET = SPACES
007220     OR NIT-USUNET = ZEROS
007230        MOVE "Validacion de Sesion"        TO MENSAJE1-HTML
007240        MOVE "Falta configurar usuarios"   TO MENSAJE2-HTML
007250        MOVE "Sc"                          TO MENSAJE3-HTML
007260        GO TO ENVIAR-ERROR
007270     END-IF.
007280 
007350
       ASIGNAR-NOMBRES.

           INITIALIZE NOM-PLANO-W NOM-USUAR-W NOM-MOV-W

           INSPECT IP-DATOS-USUNET REPLACING FIRST "/" BY "\"
007287     MOVE "\\" TO NOM-USUAR-W
007288     INSPECT NOM-USUAR-W REPLACING FIRST "                    "
007289                                    BY IP-DATOS-USUNET
007290     INSPECT NOM-USUAR-W REPLACING FIRST " "
007291                                    BY "\"
007292     INSPECT NOM-USUAR-W REPLACING FIRST "                              "
007293                                    BY DIRECTORIO-LLEGAD-W

           MOVE NOM-USUAR-W    TO NOM-MOV-W

007294     INSPECT NOM-USUAR-W REPLACING FIRST "                       "
007295                                      BY "\CONTROL\SC-ARCHUSU.DAT".


           INSPECT NOM-MOV-W REPLACING FIRST "                   "
                                          BY "\OCT\SC-ARCHMOV.DAT".

           MOVE "C:\PROSOFT\TEMP\SC-PRUEMOV-XXXXXXXXXXXXXXXXXXXXXXXXXXXXX.JSON" TO  NOM-PLANO-W

           INSPECT NOM-PLANO-W  REPLACING FIRST "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                                             BY SESION-LLEGAD-W.

        ABRIR-USUARIOS.

           OPEN INPUT ARCHIVO-USUARIOS
           READ ARCHIVO-USUARIOS NEXT WITH NO LOCK AT END 
                CLOSE ARCHIVO-USUARIOS
           END-READ.

       ABRIR-ARTICULOS.
           OPEN INPUT MOVIMIENTO-DIARIO
008123     OPEN OUTPUT ARCHIVO-JSON.
008150
008160     INITIALIZE MOV-DIARIO REG-PLANO.
008170     MOVE "{*Movimineto*:[" TO  DATOS-PLANO
008180     INSPECT DATOS-PLANO REPLACING ALL "*" BY CARAC-COMILLA
008190     WRITE REG-PLANO.
008210 
008220 LEER-ARTICULOS.

008300     READ MOVIMIENTO-DIARIO NEXT WITH NO LOCK AT END GO TO CERRAR-ARTICULOS.

           IF LOTE-MOV = "1B"
              CONTINUE
           ELSE
              GO TO LEER-ARTICULOS
           END-IF

           IF MAYOR-MOV = 1305
           OR MAYOR-MOV = 1505
           OR MAYOR-MOV = 1470
              CONTINUE
           ELSE
              GO TO LEER-ARTICULOS
           END-IF


           MOVE LLAVE-MOV TO LLAVE-J
           MOVE LOTE-MOV     TO LOT-J
           MOVE COMPROB-MOV  TO COMPR-J
           MOVE SECU-MOV     TO SEC-J
           MOVE REFER-MOV    TO REFER-J
           MOVE ULT-NRO-MOV  TO ULT-NRO-MOV-J
           MOVE FECHA-MOV    TO FECHA-MOV-J
           MOVE VALOR-MOV    TO VALOR-MOV-EDIT
           MOVE VALOR-MOV-EDIT TO VALOR-J

           MOVE "," TO CIERRE-LIN-1

           INSPECT LIN-1 REPLACING ALL "*" BY CARAC-COMILLA

           MOVE LIN-1 TO DATOS-PLANO
           WRITE REG-PLANO END-WRITE


008850     GO TO LEER-ARTICULOS.
008860
008870 CERRAR-ARTICULOS.
008880     INITIALIZE CIERRE-LIN-1
008890     MOVE LIN-1 TO DATOS-PLANO
008900     WRITE REG-PLANO.
008910
008920     MOVE "]}" TO DATOS-PLANO
008930     WRITE REG-PLANO.
008940          
008950     CLOSE MOVIMIENTO-DIARIO
008960           ARCHIVO-JSON.  

010700 PAGINA-CONFIG.  
010720     MOVE "datosrecibidos" TO COBW3-CNV-NAME
010730     MOVE 00               TO COBW3-CNV-VALUE
010740     CALL "COBW3_SET_CNV" USING COBW3
010750
010760     MOVE "..\PAGINAS\RECIBIDOS.ASPX" TO SALIDA-HTML  
010770     PERFORM ABRIR-HTML.

007980   
007990 CERRAR-SESION.
008000     CALL "COBW3_FREE" USING COBW3.
008010     MOVE 1 TO PROGRAM-STATUS.
008020     EXIT PROGRAM.

008030
008040 COPY "P:\PROG\PROYECT\FUENTES\SC-WEB.CBL".
