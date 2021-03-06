000012* CREA JSON PARA GENERAR LISTA DE GALONES ORDENADOS
000020 IDENTIFICATION DIVISION.
000021* PROGRAM-ID. "BOMB14".
000022
000023 PROGRAM-ID. "HttpExtensionProc".
000024 ENVIRONMENT DIVISION.
000025 CONFIGURATION SECTION.
000026 INPUT-OUTPUT SECTION.
000027 FILE-CONTROL.
000080 COPY "P:\PROG\PROYECT\FUENTES\FS-USUNET.CBL".
000150 COPY "P:\PROG\PROYECT\FUENTES\FS-SESION.CBL".


           SELECT ARCHIVO-USUARIOS LOCK MODE IS AUTOMATIC
                  ASSIGN TO NOM-USUAR-W
                  ORGANIZATION IS INDEXED
                  ACCESS MODE IS DYNAMIC;
                  RECORD KEY IS NOMBRE-USU
                  ALTERNATE RECORD KEY IS CTL-USU     WITH DUPLICATES
                  ALTERNATE RECORD KEY IS CLAVE-USU   WITH DUPLICATES
                  ALTERNATE RECORD KEY IS CLAVE-2-USU WITH DUPLICATES
                  FILE STATUS IS OTR-STAT.


           SELECT ARCHIVO-GALONAJES LOCK MODE IS AUTOMATIC
                  ASSIGN NOM-GALON-W
                  ORGANIZATION IS INDEXED
                  ACCESS MODE IS DYNAMIC;
                  RECORD KEY IS LLAVE-GALON
                  ALTERNATE RECORD KEY IS FECHA-GALON WITH DUPLICATES.


           SELECT ARCHIVO-SURTIDORES LOCK MODE IS AUTOMATIC
                  ASSIGN NOM-SURT-W
                  ORGANIZATION INDEXED;
                  ACCESS MODE  DYNAMIC;
                  RECORD KEY COD-SURTI
                  FILE STATUS  OTR-STAT.


           SELECT ARCHIVO-COMBUSTIBLES LOCK MODE IS AUTOMATIC
                  ASSIGN NOM-COMBU-W
                  ORGANIZATION INDEXED;
                  ACCESS MODE DYNAMIC;
                  RECORD KEY IS LLAVE-COMB
                  ALTERNATE RECORD KEY IS FECHA-COMB WITH DUPLICATES
                  FILE STATUS IS OTR-STAT.


           SELECT ARCHIVO-VENDEDOR LOCK MODE IS AUTOMATIC
                  ASSIGN NOM-VEN-W
                  ORGANIZATION IS INDEXED
                  ACCESS MODE IS DYNAMIC
                  RECORD KEY IS COD-VEN
                  FILE STATUS IS OTR-STAT.


           SELECT ARCHIVO-TERCEROS  LOCK MODE IS AUTOMATIC
                  ASSIGN NOM-TER-W
                  ORGANIZATION IS INDEXED;
                  ACCESS MODE  IS DYNAMIC
                  RECORD KEY   IS COD-TERCERO
                  ALTERNATE RECORD KEY DESCRIP-TER WITH DUPLICATES
                  ALTERNATE RECORD KEY ACT-TER     WITH DUPLICATES
                  FILE STATUS IS OTR-STAT.


           SELECT ARCHIVO-TEMPORAL   
                  ASSIGN NOM-TMP-W
                  ORGANIZATION IS INDEXED;
                  ACCESS MODE IS DYNAMIC
                  RECORD KEY IS LLAVE-TMP
                  ALTERNATE RECORD KEY IS
                  VEND-TMP WITH DUPLICATES
                  FILE STATUS IS OTR-STAT.



005030     SELECT ARCHIVO-JSON
005040            ASSIGN NOM-PLANO-W
005050            ORGANIZATION IS LINE SEQUENTIAL
005060            FILE STATUS IS OTR-STAT.


000400 DATA DIVISION.
000410 FILE SECTION.
000420 COPY "P:\PROG\PROYECT\FUENTES\FD-USUNET.CBL".
000421 COPY "P:\PROG\PROYECT\FUENTES\FD-SESION.CBL".
000450 COPY "P:\PROG\PROYECT\FUENTES\FD-USUAR.CBL".
       COPY "P:\PROG\PROYECT\FUENTES\FD-GALON.CBL".
       COPY "P:\PROG\PROYECT\FUENTES\FD-SURTI.CBL".
       COPY "P:\PROG\PROYECT\FUENTES\FD-COMBU.CBL".
       COPY "P:\PROG\PROYECT\FUENTES\FD-VENDE.CBL".
       COPY "P:\PROG\PROYECT\FUENTES\FD-TERCE.CBL".


       FD ARCHIVO-TEMPORAL
             LABEL RECORD STANDARD.
       01   REG-TMP.
            02 LLAVE-TMP.
   	         05 COMP-TMP           PIC 9(5).
	         05 SURTI-TMP.
                    07 ISLA-TMP        PIC X.
                    07 MANG-TMP        PIC X.
            02 FECHA-TMP               PIC X(6).
            02 VENTA-TMP               PIC 9(12)V99.
            02 CANT-TMP                PIC 9(12)V99.
            02 VEND-TMP                PIC X(5).


005140 FD  ARCHIVO-JSON
005150     LABEL RECORD STANDARD.
005160 01  REG-PLANO.
005170     02 DATOS-PLANO     PIC X(500).

000540 WORKING-STORAGE  SECTION.
000550 COPY "P:\PROG\PROYECT\FUENTES\COBW3.CBL".
000560 COPY "P:\PROG\PROYECT\FUENTES\WEB-CARAC.CBL".


       77 NOM-TMP-W              PIC X(70).
000570 77 NOM-USUAR-W            PIC X(70).
       77 NOM-GALON-W            PIC X(70).
       77 NOM-SURT-W             PIC X(70).
       77 NOM-COMBU-W            PIC X(70).
       77 NOM-VEN-W              PIC X(70).
       77 NOM-PLANO-W            PIC X(90).
       77 NOM-TER-W              PIC X(70).
       77 CONT                   PIC 999.

       77 GALONAJE-W             PIC ZZZZZZZZZZ.ZZZ.
       77 DESCTO-W               PIC ZZZZZZZZZZZZ.ZZZ.
       77 FECHA-SEC              PIC 9(6).
       77 VEN-W                  PIC X(5).


       01 VARIABLES.
          02 SW9                 PIC 9         VALUE 0.
          02 CONTA-LINEAS        PIC 99        VALUE 0.
          02 CONTA-PAGINAS       PIC 99        VALUE 0.
          02 VENTA-TOT           PIC 9(12)V99.
          02 CANT-TOT            PIC 9(12)V99.
          02 VENTA-DIARIA        PIC 9(12)V99.
          02 CANT-DIARIO         PIC 9(12)V99.
          02 MSJ-W           PIC X(30).
          02 VALOR-EDIT          PIC ZZZ,ZZZ,ZZZ,ZZZ.ZZ.
          02 VLR-L               PIC Z,ZZZ,ZZZ,ZZZ.ZZ.
          02 VLR-CSV             PIC -ZZZZZZZZZZZZZZZ.
          02 VLR-EDIT            PIC X(16).


       01 FECHA-W.
          02   ANO-W             PIC 99.
          02   MES-W             PIC 99.
          02   DIA-W             PIC 99.


       01 FECHA-EDIT.
          02   MES-EDIT          PIC X(8).
          02   FILLER            PIC X VALUE SPACES.
          02   DIA-EDIT          PIC ZZ.
          02   FILLER            PIC X VALUE "/".
          02   ANO-EDIT          PIC 99.


       01 VALOR-GLOBAL-W         PIC ZZZZZZZZZZZZ.ZZ.



       01 LINEA-LLEGAD-W             PIC X(100).

       01 DATO-LLEGADA-W.
          02 SESION-LLEGAD-W        PIC X(29).
          02 DIRECTORIO-LLEGAD-W    PIC X(30).
          02 CARPTA-LLEGAD-W        PIC X(9).
          02 FECHA-INI-LLEGAD-W.
             03 ANO-INI-W           PIC XX.
             03 MES-INI-W           PIC XX.
             03 DIA-INI-W           PIC XX.
          02 FECHA-FIN-LLEGAD-W.
             03 ANO-FIN-W           PIC XX.
             03 MES-FIN-W           PIC XX.
             03 DIA-FIN-W           PIC XX.

       01 DATOS-ENVIO.
          02 DAT0-ENV               PIC XX.
          02 FILLER                 PIC X VALUE "|".
          02 DAT1-ENV               PIC X(20).
          02 FILLER                 PIC X VALUE "|".
          02 DAT2-ENV               PIC X(20).


       01 LIN-1.
          02 FILLER                  PIC X(7)   VALUE "{*COD*:".
          02 FILLER                  PIC X      VALUE "*".
          02 VEND-J                  PIC X(5).
          02 FILLER                  PIC XX     VALUE "*,".       
          02 FILLER                  PIC X(9)   VALUE "*NOMBRE*:".
          02 FILLER                  PIC X      VALUE "*".
          02 NOMBRE-J                PIC X(60).
          02 FILLER                  PIC XX     VALUE "*,".       
          02 FILLER                  PIC X(11)  VALUE "*CANTIDAD*:".
          02 FILLER                  PIC X      VALUE "*".
          02 CANTIDAD-J              PIC X(20).
          02 FILLER                  PIC XX     VALUE "*,".       
          02 FILLER                  PIC X(8)   VALUE "*VALOR*:".
          02 FILLER                  PIC X      VALUE "*".
          02 VALOR-J                 PIC X(20).
003710    02 FILLER                  PIC XX     VALUE "*}".
005040    02 CIERRE-LIN-1            PIC X.


000791 LINKAGE SECTION.
000792 COPY "P:\PROG\PROYECT\FUENTES\ISAPICTX.CBL".
000793
000794 PROCEDURE DIVISION WITH stdcall LINKAGE USING ISAPI-CTX-CNT.
000795
000810 DECLARATIVES.
000811 I-O-TEST SECTION.
000812     USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-USUNET.         
000813 ESCR-EXCEPTIONES.
000814     IF OTR-STAT = "00"
000815        CONTINUE 
000816     ELSE
000817        MOVE OTR-STAT                TO MSJ1-HTML
000818        MOVE NOM-USU-W               TO MSJ2-HTML
000819        MOVE "BOMB14"                TO MSJ3-HTML
000820        GO TO ENVIAR2-ERROR
000821     END-IF.
001030
001040 I-O-TEST SECTION.
001050     USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-SESION.         
001060 ESCR-EXCEPTIONES.
001070     IF OTR-STAT = "00"
001080        CONTINUE
001090     ELSE
001100        MOVE OTR-STAT                TO MSJ1-HTML
001101        MOVE NOM-SESION-W            TO MSJ2-HTML
001102        MOVE "BOMB14"                TO MSJ3-HTML
001103        GO TO ENVIAR2-ERROR
001104     END-IF.

006600 I-O-TEST SECTION.
006610     USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-USUARIOS.
006620 ESCR-EXCEPTIONES.
006630     IF OTR-STAT = "00" 
006640        CONTINUE 
006650     ELSE
006660        MOVE OTR-STAT         TO MSJ1-HTML
006670        MOVE NOM-USUAR-W      TO MSJ2-HTML
006680        MOVE "BOMB14"         TO MSJ3-HTML
006690        GO TO ENVIAR2-ERROR
006700     END-IF.

006600 I-O-TEST SECTION.
006610     USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-GALONAJES.
006620 ESCR-EXCEPTIONES.
006630     IF OTR-STAT = "00" 
006640        CONTINUE 
006650     ELSE
006660        MOVE OTR-STAT         TO MSJ1-HTML
006670        MOVE NOM-GALON-W      TO MSJ2-HTML
006680        MOVE "BOMB14"         TO MSJ3-HTML
006690        GO TO ENVIAR2-ERROR
006700     END-IF.

006600 I-O-TEST SECTION.
006610     USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-SURTIDORES.
006620 ESCR-EXCEPTIONES.
006630     IF OTR-STAT = "00" 
006640        CONTINUE 
006650     ELSE
006660        MOVE OTR-STAT         TO MSJ1-HTML
006670        MOVE NOM-SURT-W       TO MSJ2-HTML
006680        MOVE "BOMB14"         TO MSJ3-HTML
006690        GO TO ENVIAR2-ERROR
006700     END-IF.

006600 I-O-TEST SECTION.
006610     USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-COMBUSTIBLES.
006620 ESCR-EXCEPTIONES.
006630     IF OTR-STAT = "00" 
006640        CONTINUE 
006650     ELSE
006660        MOVE OTR-STAT         TO MSJ1-HTML
006670        MOVE NOM-COMBU-W      TO MSJ2-HTML
006680        MOVE "BOMB14"         TO MSJ3-HTML
006690        GO TO ENVIAR2-ERROR
006700     END-IF.

006600 I-O-TEST SECTION.
006610     USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-VENDEDOR.
006620 ESCR-EXCEPTIONES.
006630     IF OTR-STAT = "00" 
006640        CONTINUE 
006650     ELSE
006660        MOVE OTR-STAT         TO MSJ1-HTML
006670        MOVE NOM-VEN-W        TO MSJ2-HTML
006680        MOVE "BOMB14"         TO MSJ3-HTML
006690        GO TO ENVIAR2-ERROR
006700     END-IF.

006600 I-O-TEST SECTION.
006610     USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-TERCEROS.
006620 ESCR-EXCEPTIONES.
006630     IF OTR-STAT = "00" 
006640        CONTINUE 
006650     ELSE
006660        MOVE OTR-STAT         TO MSJ1-HTML
006670        MOVE NOM-TER-W        TO MSJ2-HTML
006680        MOVE "BOMB14"         TO MSJ3-HTML
006690        GO TO ENVIAR2-ERROR
006700     END-IF.


006600 I-O-TEST SECTION.
006610     USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-JSON.
006620 ESCR-EXCEPTIONES.
006630     IF OTR-STAT = "00" OR "35"
006640        CONTINUE 
006650     ELSE
006660        MOVE OTR-STAT         TO MSJ1-HTML
006670        MOVE NOM-PLANO-W      TO MSJ2-HTML
006680        MOVE "BOMB14"         TO MSJ3-HTML
006690        GO TO ENVIAR2-ERROR
006700     END-IF.
006710

001150 END DECLARATIVES.
001160
001161 INICIAR-IIS.
001162     MOVE LOW-VALUE TO COBW3.
001163     MOVE FUNCTION ADDR(ISAPI-CTX-CNT) TO COBW3-CONTEXT.
001164     CALL "COBW3_INIT" USING COBW3.
001220
001221 LEER-DATO-HTML.
001852     MOVE "datosh" TO COBW3-SEARCH-DATA.
001853     CALL "COBW3_GET_VALUE" USING COBW3.
001854     MOVE COBW3-GET-DATA    TO LINEA-LLEGAD-W.

           INITIALIZE DATO-LLEGADA-W

           UNSTRING LINEA-LLEGAD-W DELIMITED BY "|"
              INTO SESION-LLEGAD-W, DIRECTORIO-LLEGAD-W, CARPTA-LLEGAD-W, 
                   FECHA-INI-LLEGAD-W, FECHA-FIN-LLEGAD-W
           END-UNSTRING.

001855     MOVE SESION-LLEGAD-W    TO LLAVE-SESION-W.

001238 INICIAR-SESION.
001245     MOVE "D:\WEB\MAIN-ELECT\DATOS\SC-SESION.DAT" TO NOM-SESION-W
001246
000820     MOVE FUNCTION CURRENT-DATE TO FECHA-TOTAL.
000830     ACCEPT HORA-TOTAL FROM TIME.
000810     GO TO VALIDAR-SESION.
000850
000860 FIN-VALIDAR-SESION.

001303 ABRIR-USUARIO.
001304     MOVE "D:\WEB\MAIN-ELECT\DATOS\SC-ARCHUSU.DAT" TO NOM-USU-W
001305
001306     OPEN INPUT ARCHIVO-USUNET
001307     EVALUATE OTR-STAT
001308       WHEN "00"  CONTINUE
001309       WHEN "35"  OPEN OUTPUT ARCHIVO-USUNET
001310                  CLOSE       ARCHIVO-USUNET
001311                  OPEN I-O    ARCHIVO-USUNET
001312                  INITIALIZE REG-USUNET
001314                  WRITE REG-USUNET
001315                  CLOSE       ARCHIVO-USUNET
001316                  MOVE "Validacion de usuarios"      TO MSJ1-HTML
001317                  MOVE "Falta configurar usuario"    TO MSJ2-HTML
001318                  MOVE "Sc"                          TO MSJ3-HTML
001319                  GO TO ENVIAR2-ERROR
001320       WHEN OTHER GO TO CERRAR-SESION
001321     END-EVALUATE.
001322
001332     INITIALIZE REG-USUNET.

007110 LEER-USUARIO.
007120     READ ARCHIVO-USUNET NEXT AT END MOVE 0 TO SW-FIN.
007130
007140     CLOSE ARCHIVO-USUNET.
007200     
007210     IF NOMBRE-USUNET = SPACES
007220     OR NIT-USUNET = ZEROS
007230        MOVE "Validacion de Sesion"        TO MSJ1-HTML
007240        MOVE "Falta configurar usuarios"   TO MSJ2-HTML
007250        MOVE "Sc"                          TO MSJ3-HTML
007260        GO TO ENVIAR2-ERROR
007270     END-IF.

       INICIAR-RESTRICION.

           INSPECT IP-DATOS-USUNET REPLACING FIRST "/" BY "\"
001614     INITIALIZE NOM-USUAR-W NOM-GALON-W NOM-SURT-W NOM-COMBU-W NOM-VEN-W NOM-PLANO-W
001615     MOVE "\\" TO NOM-USUAR-W NOM-TER-W
001616
001617     INSPECT NOM-USUAR-W REPLACING FIRST "                    "
001618                                    BY IP-DATOS-USUNET
001621     INSPECT NOM-USUAR-W REPLACING FIRST " "
001624                                     BY "\"
007292     INSPECT NOM-USUAR-W REPLACING FIRST "                              "
007293                                     BY DIRECTORIO-LLEGAD-W

           MOVE NOM-USUAR-W  TO NOM-GALON-W NOM-SURT-W NOM-COMBU-W NOM-VEN-W NOM-TER-W

           INSPECT NOM-USUAR-W  REPLACING FIRST "                       "
                                             BY "\CONTROL\SC-ARCHUSU.DAT".

           INSPECT NOM-GALON-W  REPLACING FIRST "                       "
                                             BY "\CONTROL\SC-ARCHGAL.DAT".

           INSPECT NOM-SURT-W   REPLACING FIRST "                       "
                                             BY "\CONTROL\SC-ARCHSUR.DAT".

           INSPECT NOM-COMBU-W  REPLACING FIRST "                       "
                                             BY "\CONTROL\SC-ARCOMBU.DAT".

           INSPECT NOM-VEN-W    REPLACING FIRST "                       "
                                             BY "\CONTROL\SC-ARCHVEN.DAT".

           INSPECT NOM-TER-W    REPLACING FIRST "                       "
                                             BY "\CONTROL\SC-ARCHTER.DAT".



           MOVE "C:\PROSOFT\TEMP\SC-LISTGAL-XXXXXXXXXXXXXXXXXXXXXXXXXXXXX.JSON" TO  NOM-PLANO-W

           INSPECT NOM-PLANO-W  REPLACING FIRST "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                                             BY SESION-LLEGAD-W.

       LEER-USUARIO.

           OPEN INPUT ARCHIVO-USUARIOS
           READ ARCHIVO-USUARIOS NEXT WITH NO LOCK AT END 
                CLOSE ARCHIVO-USUARIOS
           END-READ.

       ABRIR-ARCHIVOS.

           OPEN INPUT ARCHIVO-GALONAJES
                      ARCHIVO-VENDEDOR.

       LEER-GALONAJES.

           MOVE FECHA-INI-LLEGAD-W     TO FECHA-GALON

           START ARCHIVO-GALONAJES KEY >= FECHA-GALON
                 INVALID KEY 
                         MOVE "99"       TO MSJ1-HTML
                         MOVE "8"        TO MSJ2-HTML
                         MOVE "BOM108"   TO MSJ3-HTML
                         GO TO ENVIAR2-ERROR
           END-START.


       ABRIR-TEMPORAL.

           MOVE "C:\PROSOFT\TEMP\AAAAT1T1T1.L" TO NOM-TMP-W
           OPEN OUTPUT ARCHIVO-TEMPORAL
           CLOSE ARCHIVO-TEMPORAL
           INITIALIZE CONT
           OPEN I-O ARCHIVO-TEMPORAL.

       ESCRIBIR-TEMPORAL.
           READ ARCHIVO-GALONAJES NEXT WITH NO LOCK AT END GO TO CERRAR-TEMPORAL.

           IF FECHA-GALON > FECHA-FIN-LLEGAD-W GO TO CERRAR-TEMPORAL.

           MOVE LLAVE-GALON    TO LLAVE-TMP
           MOVE VENTA-GALON    TO VENTA-TMP
           MOVE CANT-GALON     TO CANT-TMP
           MOVE VEND-GALON     TO VEND-TMP

           WRITE REG-TMP END-WRITE

           GO TO ESCRIBIR-TEMPORAL.

       CERRAR-TEMPORAL.
           CLOSE ARCHIVO-GALONAJES
                 ARCHIVO-TEMPORAL.

           OPEN INPUT ARCHIVO-TEMPORAL.


       INICIALIZAR-ARCHIVO.
           INITIALIZE VEND-TMP VARIABLES REG-TMP
           START ARCHIVO-TEMPORAL KEY >= VEND-TMP
                 INVALID KEY 
                         MOVE "99"      TO MSJ1-HTML
                         MOVE "No hay movimiento en el temporal" TO MSJ2-HTML
                         MOVE "BOMB14"  TO MSJ3-HTML
                         GO TO ENVIAR2-ERROR
           END-START.



       ABRIR-JSON.

008123     OPEN OUTPUT ARCHIVO-JSON.

008160     INITIALIZE REG-PLANO VARIABLES REG-TMP.
008170     MOVE "{*LISTADO*:[" TO  DATOS-PLANO
008180     INSPECT DATOS-PLANO REPLACING ALL "*" BY CARAC-COMILLA
008190     WRITE REG-PLANO.


       LEER-GALONAJE.
           READ ARCHIVO-TEMPORAL NEXT WITH NO LOCK AT END 
                PERFORM TOTAL-VENDEDOR
                PERFORM GRAN-TOTAL
                GO TO CERRAR-GALONAJE
           END-READ
           IF SW9 = 0
              MOVE 1  TO SW9
              MOVE VEND-TMP   TO VEN-W
           END-IF

           IF VEND-TMP IS NOT EQUAL TO VEN-W
              PERFORM TOTAL-VENDEDOR
              MOVE VEND-TMP   TO VEN-W
              INITIALIZE CANT-DIARIO VENTA-DIARIA
           END-IF

           ADD VENTA-TMP    TO VENTA-DIARIA
           ADD CANT-TMP     TO CANT-DIARIO

           GO TO LEER-GALONAJE.


       TOTAL-VENDEDOR.

           MOVE VEN-W   TO COD-VEN
           READ ARCHIVO-VENDEDOR WITH NO LOCK
                INVALID KEY 
                        MOVE SPACES TO NOMBRE-J
                NOT INVALID KEY 
                        PERFORM LEER-TERCERO
           END-READ

           MOVE VEN-W        TO VEND-J

           MOVE CANT-DIARIO  TO VLR-L
           MOVE VLR-L        TO CANTIDAD-J

           MOVE VENTA-DIARIA TO VLR-L
           MOVE VLR-L        TO VALOR-J

           ADD CANT-DIARIO   TO CANT-TOT
           ADD VENTA-DIARIA  TO VENTA-TOT

           MOVE ","               TO CIERRE-LIN-1
           INSPECT LIN-1 REPLACING ALL "*" BY CARAC-COMILLA

           MOVE LIN-1 TO DATOS-PLANO
           WRITE REG-PLANO END-WRITE.


       GRAN-TOTAL.

           MOVE CANT-TOT    TO VALOR-EDIT
           MOVE VALOR-EDIT  TO DAT1-ENV

           MOVE VENTA-TOT   TO VALOR-EDIT
           MOVE VALOR-EDIT  TO DAT2-ENV

           MOVE 00          TO DAT0-ENV.


       CERRAR-GALONAJE.

008880     INITIALIZE CIERRE-LIN-1
008890     MOVE LIN-1 TO DATOS-PLANO
008900     WRITE REG-PLANO.
008910
008920     MOVE "]}" TO DATOS-PLANO
008930     WRITE REG-PLANO.
008940          
008950     CLOSE ARCHIVO-JSON
                 ARCHIVO-GALONAJES
                 ARCHIVO-VENDEDOR.


002147 ENVIO-DATOS.
004378     MOVE "datosrecibidos"  TO COBW3-CNV-NAME
004393     MOVE DATOS-ENVIO        TO COBW3-CNV-VALUE
004403     CALL "COBW3_SET_CNV"   USING COBW3
004413     MOVE "../PAGINAS/RECIBIDOS.ASPX"  TO SALIDA-HTML
004430     PERFORM ABRIR-HTML.

002545 CERRAR-SESION.
002546     CALL "COBW3_FREE" USING COBW3.
002547     MOVE 1 TO PROGRAM-STATUS.
002548     EXIT PROGRAM.

       LEER-TERCERO.

           OPEN INPUT ARCHIVO-TERCEROS.
           MOVE NIT-VEN   TO COD-TER
           READ ARCHIVO-TERCEROS  WITH NO LOCK
                INVALID KEY
                        MOVE SPACES   TO NOMBRE-J
                NOT INVALID KEY 
                        MOVE DESCRIP-TER  TO NOMBRE-J
           END-READ.


           CLOSE ARCHIVO-TERCEROS.

002566 COPY "P:\PROG\PROYECT\FUENTES\SC-WEB.CBL".
002567
