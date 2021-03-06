      *=================================================================
      * CONSULTA DATOS DE NUMERACION 
      *=================================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. "HttpExtensionProc".
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           COPY "..\..\FUENTES\FS-USUNET.CBL".
           COPY "..\..\FUENTES\FS-SESION.CBL".
  
           SELECT ARCHIVO-USUARIOS LOCK MODE IS AUTOMATIC
                  ASSIGN NOM-USUAR-W
                  ORGANIZATION IS INDEXED
                  ACCESS MODE IS DYNAMIC;
                  RECORD KEY IS NOMBRE-USU
                  ALTERNATE RECORD KEY IS CTL-USU     WITH DUPLICATES
                  ALTERNATE RECORD KEY IS CLAVE-USU   WITH DUPLICATES
                  ALTERNATE RECORD KEY IS CLAVE-2-USU WITH DUPLICATES
                  FILE STATUS IS OTR-STAT.

           SELECT ARCHIVO-NUMERACION LOCK MODE IS AUTOMATIC
                  ASSIGN NOM-NUMER-W
                  ORGANIZATION IS INDEXED;
                  ACCESS MODE  IS DYNAMIC
                  RECORD KEY   IS LLAVE-NUM
		  ALTERNATE RECORD KEY NIT-NUM         WITH DUPLICATES
                  ALTERNATE RECORD KEY DESCRIP-NUM     WITH DUPLICATES
                  ALTERNATE RECORD KEY NOMBRE-PAC-NUM  WITH DUPLICATES
                  ALTERNATE RECORD KEY HAB-NUM         WITH DUPLICATES
                  ALTERNATE RECORD KEY FECHA-ING-NUM   WITH DUPLICATES
                  ALTERNATE RECORD KEY FECHA-RET-NUM   WITH DUPLICATES
                  FILE STATUS IS OTR-STAT.

       DATA DIVISION.
       FILE SECTION.
       COPY "..\..\FUENTES\FD-USUNET.CBL".
       COPY "..\..\FUENTES\FD-SESION.CBL".
       COPY "..\..\FUENTES\FD-USUAR.CBL".
       COPY "..\..\FUENTES\FD-NUMER.CBL".

005190 WORKING-STORAGE SECTION.
005200 COPY "..\..\FUENTES\COBW3.CBL".
005210 COPY "..\..\FUENTES\WEB-CARAC.CBL".

       77 NOM-USUAR-W                     PIC X(70).
       77 NOM-NUMER-W                     PIC X(70).

       01 DATO-LLEGADA-W.
          02 LLAVE-SESION-LLEGAD-W.
             03 ID-LLEGAD-W               PIC X(15).
             03 FECHA-LLEGAD-W            PIC X(8).
             03 HORA-LLEGAD-W             PIC X(6).
          02 DIR-CONTAB-LLEGADA-W         PIC X(8).
          02 MES-CONTAB-LLEGADA-W         PIC XX.
          02 LLAVE-W.
             05 PREFIJO-W                 PIC X.
             05 NRO-W                     PIC 9(6).

       01 DATOS-ENVIO.
          02 ESTADO-ENVIO                 PIC XX.         
          02 FILLER                       PIC X      VALUE "|".
          02 SW-INVALID-ENV               PIC XX.
          02 FILLER                       PIC X      VALUE "|".
          02 NIT-NUM-ENV                  PIC 9(10).
          02 FILLER                       PIC X      VALUE "|".
          02 CONVENIO-NUM-ENV             PIC XX.
          02 FILLER                       PIC X      VALUE "|".
          02 ESTADO-NUM-ENV               PIC X.
          02 FILLER                       PIC X      VALUE "|".
          02 ID-PAC-NUM-ENV               PIC X(15).
          02 FILLER                       PIC X      VALUE "|".
          02 FECHA-ING-NUM-ENV.
             05 LLAVE-MES-ING-NUM-ENV.
                07 ANO-ING-NUM-ENV        PIC 9(4).
                07 MES-ING-NUM-ENV        PIC 99.
             05 DIA-ING-NUM-ENV           PIC 99.
          02 FILLER                       PIC X      VALUE "|".
          02 FECHA-RET-NUM-ENV.
             05 LLAVE-MES-RET-NUM-ENV.
                07 ANO-RET-NUM-ENV        PIC 9(4).
                07 MES-RET-NUM-ENV        PIC 99.
             05 DIA-RET-NUM-ENV           PIC 99.
      
       01 LINEA-LLEGADA-W                 PIC X(100).

006310 LINKAGE SECTION.
006320 COPY "..\..\FUENTES\ISAPICTX.CBL".
006330 PROCEDURE DIVISION WITH stdcall LINKAGE USING ISAPI-CTX-CNT.
006340
006350 DECLARATIVES.
       I-O-TEST SECTION.
           USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-USUNET.         
       ESCR-EXCEPTIONES.
           IF OTR-STAT = "00"
              CONTINUE 
           ELSE
              MOVE OTR-STAT                 TO MSJ1-HTML
              MOVE NOM-USU-W                TO MSJ2-HTML
              MOVE "SER108-03"              TO MSJ3-HTML
              GO TO ENVIAR2-ERROR
           END-IF.
       I-O-TEST SECTION.
           USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-SESION.         
       ESCR-EXCEPTIONES.                                                                                                                                
           IF OTR-STAT = "00"
              CONTINUE
           ELSE
              MOVE OTR-STAT                 TO MSJ1-HTML
              MOVE NOM-SESION-W             TO MSJ2-HTML
              MOVE "SER108-03"              TO MSJ3-HTML
              GO TO ENVIAR2-ERROR
           END-IF.
       I-O-TEST SECTION.
           USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-USUARIOS.
       ESCR-EXCEPTIONES.
           IF OTR-STAT = "00"
              CONTINUE            
           ELSE
              MOVE OTR-STAT             TO MSJ1-HTML
              MOVE NOM-USUAR-W          TO MSJ2-HTML
              MOVE "SER108-03"          TO MSJ3-HTML
              GO TO ENVIAR2-ERROR
           END-IF.
       I-O-TEST SECTION.
           USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-NUMERACION.
       ESCR-EXCEPTIONES.
           IF OTR-STAT = "00"
              CONTINUE            
           ELSE
              MOVE OTR-STAT             TO MSJ1-HTML
              MOVE NOM-NUMER-W          TO MSJ2-HTML
              MOVE "SER108-03"          TO MSJ3-HTML
              GO TO ENVIAR2-ERROR
           END-IF.
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
006820     MOVE COBW3-GET-DATA    TO LINEA-LLEGADA-W.

           UNSTRING LINEA-LLEGADA-W DELIMITED BY "|"
               INTO LLAVE-SESION-LLEGAD-W, DIR-CONTAB-LLEGADA-W, MES-CONTAB-LLEGADA-W, LLAVE-W
           END-UNSTRING.

001855     MOVE LLAVE-SESION-LLEGAD-W  TO LLAVE-SESION-W.
           MOVE FUNCTION CURRENT-DATE  TO FECHA-TOTAL.

000797 INICIAR-SESION.
000806     MOVE "D:\progelect\DATOS\SC-SESION.DAT" TO NOM-SESION-W
000810     GO TO VALIDAR-SESION.
000850
000860 FIN-VALIDAR-SESION.
006840
006900 ABRIR-USUARIO.
006910     INITIALIZE OTR-STAT.
006920     MOVE "D:\progelect\DATOS\SC-ARCHUSU.DAT" TO NOM-USU-W
006930
006940     OPEN INPUT ARCHIVO-USUNET
006950     EVALUATE OTR-STAT
006960       WHEN "00"  CONTINUE
006970       WHEN "35"  OPEN OUTPUT ARCHIVO-USUNET
006980                  INITIALIZE REG-USUNET
006990                  WRITE REG-USUNET
007000                  CLOSE ARCHIVO-USUNET
007010                  MOVE "Validacion de Usuario"       TO MSJ1-HTML
007020                  MOVE "Falta configurar usuarios"   TO MSJ2-HTML
007030                  MOVE "Sc"                          TO MSJ3-HTML
007040                  GO TO ENVIAR2-ERROR
007050       WHEN OTHER GO TO CERRAR-SESION
007060     END-EVALUATE.
007070
007080     INITIALIZE LLAVE-USUNET.

007100
007110 LEER-USUARIO.
007120     READ ARCHIVO-USUNET NEXT AT END MOVE 0 TO SW-FIN.
007140     CLOSE ARCHIVO-USUNET.
007200     
007210     IF NOMBRE-USUNET = SPACES
007230        MOVE "Validacion de Sesion"                  TO MSJ1-HTML
007240        MOVE "Falta configurar usuarios"             TO MSJ2-HTML
007250        MOVE "Sc"                                    TO MSJ3-HTML
007260        GO TO ENVIAR2-ERROR
007270     END-IF.
007280 
007350

        ASIGNAR-NOMBRES. 

           INITIALIZE NOM-USUAR-W NOM-NUMER-W 

           MOVE "\\" TO NOM-USUAR-W NOM-NUMER-W

           INSPECT IP-DATOS-USUNET REPLACING ALL "/" BY "\".

           INSPECT NOM-USUAR-W REPLACING FIRST "                    "
                                            BY IP-DATOS-USUNET

           INSPECT NOM-USUAR-W REPLACING FIRST " "
                                            BY "\"

           INSPECT NOM-USUAR-W REPLACING FIRST "        "
                                            BY DIR-CONTAB-LLEGADA-W.
           
           MOVE NOM-USUAR-W    TO NOM-NUMER-W

           INSPECT NOM-USUAR-W REPLACING FIRST "                       "
                                            BY "\CONTROL\SC-ARCHUSU.DAT"

           INSPECT NOM-NUMER-W REPLACING FIRST "                     "
                                            BY "\CONTROL\SC-NUMER.DAT".

       ABRIR-ARCHIVOS.

           OPEN INPUT ARCHIVO-USUARIOS.
           READ ARCHIVO-USUARIOS NEXT WITH NO LOCK AT END 
                CLOSE ARCHIVO-USUARIOS
           END-READ.

           OPEN INPUT ARCHIVO-NUMERACION.
           READ ARCHIVO-NUMERACION NEXT WITH NO LOCK AT END
                CLOSE ARCHIVO-NUMERACION
           END-READ.
          
           MOVE LLAVE-W TO LLAVE-NUM
           READ ARCHIVO-NUMERACION INVALID KEY 
                                   MOVE "01" TO SW-INVALID
                                   NOT INVALID KEY
                                   MOVE "00" TO SW-INVALID
           END-READ.           

       DATOS.
     
           MOVE "00"           TO ESTADO-ENVIO
           MOVE SW-INVALID     TO SW-INVALID-ENV
           MOVE NIT-NUM        TO NIT-NUM-ENV
           MOVE CONVENIO-NUM   TO CONVENIO-NUM-ENV
           MOVE ESTADO-NUM     TO ESTADO-NUM-ENV
           MOVE ID-PAC-NUM     TO ID-PAC-NUM-ENV
           MOVE FECHA-ING-NUM  TO FECHA-ING-NUM-ENV 
           MOVE FECHA-RET-NUM  TO FECHA-RET-NUM-ENV.

010700  PAGINA-CONFIG.
010720     MOVE "datosrecibidos" TO COBW3-CNV-NAME
010730     MOVE DATOS-ENVIO       TO COBW3-CNV-VALUE
010740     CALL "COBW3_SET_CNV"  USING COBW3
010750
010760     MOVE "..\PAGINAS\RECIBIDOS.ASPX" TO SALIDA-HTML  
010770     PERFORM ABRIR-HTML.
007980   
007990 CERRAR-SESION.
008000     CALL "COBW3_FREE" USING COBW3.
008010     MOVE 1 TO PROGRAM-STATUS.
008020     EXIT PROGRAM.

008030
008040 COPY "..\..\FUENTES\SC-WEB.CBL".
005210* COPY "..\..\FUENTES\WS-HCEVO.CBL".

