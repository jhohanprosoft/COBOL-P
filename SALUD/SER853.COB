      *=================================================================
      *CREA, ENVIA OBJETO ENTIDADES - SER853
      *=================================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. "HttpExtensionProc".
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       COPY "..\..\FUENTES\FS-USUNET.CBL".
       COPY "..\..\FUENTES\FS-SESION.CBL".
      
           SELECT ARCHIVO-ENTIDADES LOCK MODE IS AUTOMATIC
                  ASSIGN NOM-ENTI-W
                  ORGANIZATION IS INDEXED;
                  ACCESS MODE  IS DYNAMIC
                  RECORD KEY   IS COD-ENT
                  ALTERNATE RECORD KEY IS NOMBRE-ENT WITH DUPLICATES
                  FILE STATUS IS OTR-STAT.                  
                  
       DATA DIVISION.
       FILE SECTION.
       COPY "..\..\FUENTES\FD-USUNET.CBL".
       COPY "..\..\FUENTES\FD-SESION.CBL".
       COPY "..\..\FUENTES\FD-ENTID.CBL".
      
       WORKING-STORAGE SECTION.
       COPY "..\..\FUENTES\COBW3.CBL".
       COPY "..\..\FUENTES\WEB-CARAC19.CBL".
       
       77 NOM-ENTI-W                   PIC X(100).
       77 CONT                         PIC 9(4).
       77 DATOS-PLANO-W                PIC X(200).

       01 LLEGADA-W                    PIC X(100).

       01  DATO-LLEGADA-W.
          02 LLAVE-SESION-LLEGA-W.
            03 ID-LLEGAD-W            PIC X(15).
            03 FECHA-LLEGAD-W         PIC X(8).
            03 HORA-LLEGAD-W          PIC X(6).
          02 DIR-CONTAB-LLEGADA-W     PIC X(20).
          02 MES-CONTAB-LLEGADA-W     PIC XX.

       01 LIN-1.
          02 FILLER                  PIC X(11)  VALUE "{*COD-ENT*:".
          02 FILLER                  PIC X      VALUE "*".
          02 COD-ENT-J               PIC X(6).

          02 FILLER                  PIC XX     VALUE "*,".
          02 FILLER                  PIC X(13)  VALUE "*NOMBRE-ENT*:".
          02 FILLER                  PIC X      VALUE "*".
          02 NOMBRE-ENT-J            PIC X(70).
          02 FILLER                  PIC XX     VALUE "*,".
          02 FILLER                  PIC X(10)   VALUE "*NIT-ENT*:".
          02 FILLER                  PIC X      VALUE "*".
          02 NIT-ENT-J               PIC X(10).
          02 FILLER                  PIC XX     VALUE "*,".
          02 FILLER                  PIC X(11)  VALUE "*DV-ENT*:".
          02 FILLER                  PIC X      VALUE "*".
          02 DV-ENT-J                PIC X.
          02 FILLER                  PIC XX     VALUE "*,".
          02 FILLER                  PIC X(12)  VALUE "*RUBRO-ENT*:".
          02 FILLER                  PIC X      VALUE "*".
          02 RUBRO-ENT-J             PIC X(19).
          02 FILLER                  PIC XX     VALUE "*}".
          02 CIERRE-LIN-1            PIC X.
       
       LINKAGE SECTION.
       COPY "..\..\FUENTES\ISAPICTX.CBL".
       PROCEDURE DIVISION WITH stdcall LINKAGE USING ISAPI-CTX-CNT.
      
       DECLARATIVES.
       I-O-TEST SECTION.
           USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-USUNET.         
       ESCR-EXCEPTIONES.
           IF OTR-STAT = "00"
              CONTINUE  
           ELSE
              MOVE OTR-STAT         TO MSJ1-HTML
              MOVE NOM-USU-W        TO MSJ2-HTML
              MOVE "SER853"         TO MSJ3-HTML
              GO TO ENVIAR2-ERROR
           END-IF.
      
       I-O-TEST SECTION.
           USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-SESION.
       ESCR-EXCEPTIONES.
           IF OTR-STAT = "00" 
              CONTINUE 
           ELSE
              MOVE OTR-STAT         TO MSJ1-HTML
              MOVE NOM-SESION-W     TO MSJ2-HTML
              MOVE "SER853"         TO MSJ3-HTML
              GO TO ENVIAR2-ERROR
           END-IF.

        I-O-TEST SECTION.
           USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-ENTIDADES.
       ESCR-EXCEPTIONES.
           IF OTR-STAT = "00" OR "35"
              CONTINUE
           ELSE
              MOVE OTR-STAT                 TO MSJ1-HTML
              MOVE NOM-ENTI-W               TO MSJ2-HTML
              MOVE "SER853"                 TO MSJ3-HTML
              GO TO ENVIAR2-ERROR
           END-IF.

        END DECLARATIVES.
      
       INICIAR-IIS.
           MOVE LOW-VALUE TO COBW3.
           MOVE FUNCTION ADDR(ISAPI-CTX-CNT) TO COBW3-CONTEXT.
           CALL "COBW3_INIT" USING COBW3.
      
       LEER-DATO-HTML.
           MOVE "datosh" TO COBW3-SEARCH-DATA.
           CALL "COBW3_GET_VALUE" USING COBW3.
           MOVE COBW3-GET-DATA    TO LLEGADA-W.

           UNSTRING LLEGADA-W DELIMITED BY "|"
              INTO LLAVE-SESION-LLEGA-W, DIR-CONTAB-LLEGADA-W, MES-CONTAB-LLEGADA-W
           END-UNSTRING.  
          
           MOVE LLAVE-SESION-LLEGA-W    TO LLAVE-SESION-W.
           MOVE FUNCTION CURRENT-DATE TO FECHA-TOTAL.
           ACCEPT HORA-TOTAL FROM TIME.

       INICIAR-SESION.
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
007010                  MOVE "SC-2"                       TO MSJ1-HTML
007020                  MOVE "Falta configurar usuarios"  TO MSJ2-HTML
007030                  MOVE "SER853"                     TO MSJ3-HTML
007040                  GO TO ENVIAR2-ERROR
007050      WHEN OTHER GO TO CERRAR-SESION
007060     END-EVALUATE.

007110 LEER-USUARIO.
007120     READ ARCHIVO-USUNET NEXT AT END MOVE 0 TO SW-FIN.
007140     CLOSE ARCHIVO-USUNET.
007200     
           IF NOMBRE-USUNET = SPACES
007220     OR NIT-USUNET = ZEROS
007230        MOVE "SC-2"      TO MSJ1-HTML
007240        MOVE "Falta configurar usuarios" TO MSJ2-HTML
007250        MOVE "SER853"    TO MSJ3-HTML
007260        GO TO ENVIAR2-ERROR
007270     END-IF.

       ASIGNAR-NOMBRES.

           INITIALIZE NOM-ENTI-W
           MOVE "\\" TO NOM-ENTI-W
           INSPECT IP-DATOS-USUNET REPLACING FIRST "/" BY "\"

           INSPECT NOM-ENTI-W REPLACING FIRST "                    "
                                             BY IP-DATOS-USUNET

           INSPECT NOM-ENTI-W REPLACING FIRST " "
                                             BY "\"
           INSPECT NOM-ENTI-W REPLACING FIRST  "                         "
                                            BY "PROG\DATOS\SC-ARCHENT.DAT".
           
       ABRIR-ARCHIVOS.
           OPEN INPUT ARCHIVO-ENTIDADES.

       CREAR-OBJ-ENTIDADES. 
007610     INITIALIZE REG-ENT.

007620     MOVE "{*ENTIDADES*:[" TO  DATOS-PLANO-W 
007630     INSPECT DATOS-PLANO-W  REPLACING ALL "*" BY CARAC-COMILLA
           PERFORM DATOS-ENVIO
007650     MOVE 0 TO SW-FIN.
007660
007670 LEER-ENTIDADES.
007680     IF SW-FIN = 0
              MOVE 1 TO SW-FIN
           ELSE
              MOVE LIN-1 TO DATOS-PLANO-W
              PERFORM DATOS-ENVIO
           END-IF
           READ ARCHIVO-ENTIDADES NEXT WITH NO LOCK AT END
                GO TO CERRAR-ENTIDADES
           END-READ.

           IF COD-ENT = SPACES OR LOW-VALUES
              MOVE 0 TO SW-FIN
           ELSE
              IF COD-ENT = COD-ENT-J
                 MOVE 0 TO SW-FIN 
              ELSE
                 ADD 1 TO CONT 
                 INITIALIZE LIN-1
           
                 INSPECT COD-ENT REPLACING ALL '-' BY "0"
                 MOVE COD-ENT    TO COD-ENT-J
           
                 INSPECT NOMBRE-ENT REPLACING ALL '"'  BY " "
                 INSPECT NOMBRE-ENT REPLACING ALL "*"  BY " "
                 INSPECT NOMBRE-ENT REPLACING ALL "�"  BY CARAC-ENE-MAY
                 INSPECT NOMBRE-ENT REPLACING ALL "�"  BY CARAC-ENE-MIN

                 MOVE NOMBRE-ENT      TO NOMBRE-ENT-J
                 MOVE NIT-ENT         TO NIT-ENT-J
                 MOVE DV-ENT          TO DV-ENT-J
                 MOVE RUBRO-ENT       TO RUBRO-ENT-J

                 INSPECT LIN-1 REPLACING ALL "*" BY CARAC-COMILLA
                 INSPECT LIN-1 REPLACING ALL LOW-VALUES BY SPACES
                 MOVE ","               TO CIERRE-LIN-1
              END-IF   
           END-IF   
           GO TO LEER-ENTIDADES.

       CERRAR-ENTIDADES.
           INITIALIZE LIN-1
           MOVE LIN-1 TO DATOS-PLANO-W
           INSPECT LIN-1 REPLACING ALL "*" BY CARAC-COMILLA
           PERFORM DATOS-ENVIO

           MOVE "]}" TO DATOS-PLANO-W
           PERFORM DATOS-ENVIO
           CLOSE ARCHIVO-ENTIDADES.

010700 PAGINA-CONFIG.
010720     MOVE "statuscode" TO COBW3-CNV-NAME
010730     MOVE "00"         TO COBW3-CNV-VALUE
010740     CALL "COBW3_SET_CNV" USING COBW3

010720     MOVE "programa-id" TO COBW3-CNV-NAME
010730     MOVE "SER853"      TO COBW3-CNV-VALUE
010740     CALL "COBW3_SET_CNV" USING COBW3

010760     MOVE "..\PAGINAS\RECIBIDOSLISTADO.ASPX" TO SALIDA-HTML
010770     PERFORM ABRIR-HTML.

007990 CERRAR-SESION.
008000     CALL "COBW3_FREE" USING COBW3.
008010     MOVE 1 TO PROGRAM-STATUS.
008020     EXIT PROGRAM.

       VENTANA-OTROS-DATOS.


       DATOS-ENVIO.
010720     MOVE "datosrecibidos"   TO COBW3-CNV-NAME
010730     MOVE DATOS-PLANO-W      TO COBW3-CNV-VALUE
010740     CALL "COBW3_SET_REPEAT" USING COBW3.  

008040 COPY "..\..\FUENTES\SC-WEB19.CBL".
