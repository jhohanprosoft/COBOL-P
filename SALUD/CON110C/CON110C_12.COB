      *=================================================================
      * CONSULTA DE ARCHIVO ENTIDADES CON802D  
      *=================================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. "HttpExtensionProc".
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.                                     
       COPY "..\..\FUENTES\FS-USUNET.CBL".
       COPY "..\..\FUENTES\FS-SESION.CBL".  

             SELECT ARCHIVO-TERCEROS  LOCK MODE IS AUTOMATIC
                    ASSIGN NOM-TER-W
                    ORGANIZATION IS INDEXED;
                    ACCESS MODE  IS DYNAMIC
                    RECORD KEY   IS COD-TERCERO
                    ALTERNATE RECORD KEY DESCRIP-TER WITH DUPLICATES
                    ALTERNATE RECORD KEY ACT-TER     WITH DUPLICATES
                    FILE STATUS IS OTR-STAT.

       DATA DIVISION.
       FILE SECTION.
       COPY "..\..\FUENTES\FD-USUNET.CBL".
       COPY "..\..\FUENTES\FD-SESION.CBL".
       COPY "..\..\FUENTES\FD-TERCE.CBL".
     
       WORKING-STORAGE SECTION.
       COPY "..\..\FUENTES\COBW3.CBL".
       COPY "..\..\FUENTES\WEB-CARAC.CBL".

       01 LLEGADA-W                    PIC X(100).
       77 NOM-TER-W                    PIC X(70).
       01 NOMBRE-TER-LNK               PIC X(30).

       01 DATO-LLEGADA-W.
          02 LLAVE-SESION-LLEGA-W.
             03 ID-LLEGAD-W            PIC X(15).
             03 FECHA-LLEGAD-W         PIC X(8).
             03 HORA-LLEGAD-W          PIC X(6).
          02 DIR-CONTAB-LLEGADA-W      PIC X(30).
          02 MES-CONTAB-LLEGADA-W      PIC XX.
          02 OPERADOR-LLEGADA-W        PIC X(4).
          02 COD-TERCERO-LLEGADA-W.
             03 COD-TER                PIC 9(10).        
        
       01 DATOS-ENVIO.
          02 SW-INVALID-ENV            PIC X(2).            
          02 FILLER                    PIC X VALUE "|".
          02 DESCRIP-TERCE-ENV          PIC X(30).
               
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
              MOVE OTR-STAT                 TO MSJ1-HTML
              MOVE NOM-USU-W                TO MSJ2-HTML
              MOVE "CON110C_12"             TO MSJ3-HTML
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
              MOVE "CON110C_12"             TO MSJ3-HTML
              GO TO ENVIAR2-ERROR
           END-IF.

       I-O-TEST SECTION.
           USE AFTER EXCEPTION PROCEDURE ON ARCHIVO-TERCEROS.
       ESCR-EXCEPTIONES.
           IF OTR-STAT = "00"
              CONTINUE 
           ELSE
              MOVE OTR-STAT                 TO MSJ1-HTML
              MOVE NOM-TER-W                TO MSJ2-HTML
              MOVE "CON110C_12"             TO MSJ3-HTML
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
              INTO LLAVE-SESION-LLEGA-W, DIR-CONTAB-LLEGADA-W, MES-CONTAB-LLEGADA-W, OPERADOR-LLEGADA-W,
                   COD-TERCERO-LLEGADA-W
                     
           END-UNSTRING.

           MOVE LLAVE-SESION-LLEGA-W    TO LLAVE-SESION-W.
           MOVE FUNCTION CURRENT-DATE TO FECHA-TOTAL.
           ACCEPT HORA-TOTAL FROM TIME.


       INICIAR-SESION.
           MOVE "D:\WEB\MAIN-ELECT\DATOS\SC-SESION.DAT" TO NOM-SESION-W

      *     MOVE "D:\progelect\DATOS\SC-SESION.DAT" TO NOM-SESION-W
          
           GO TO VALIDAR-SESION.

       FIN-VALIDAR-SESION.

       ABRIR-USUARIO.
           INITIALIZE OTR-STAT
           MOVE "D:\WEB\MAIN-ELECT\DATOS\SC-ARCHUSU.DAT" TO NOM-USU-W

      *     MOVE "D:\progelect\DATOS\SC-ARCHUSU.DAT" TO NOM-USU-W
      
           OPEN INPUT ARCHIVO-USUNET
      
           INITIALIZE LLAVE-USUNET.

       LEER-USUARIO.           
           READ ARCHIVO-USUNET NEXT AT END MOVE 0 TO SW-FIN.
           CLOSE ARCHIVO-USUNET.
      
           IF NOMBRE-USUNET = SPACES
              MOVE "Validacion de usuarios"      TO MSJ1-HTML
              MOVE "Falta configurar usuario"    TO MSJ2-HTML
              MOVE "Sc"                          TO MSJ3-HTML
              GO TO ENVIAR2-ERROR
           END-IF.
 
       ASIGNAR-NOMBRES.                  
         
           INITIALIZE NOM-TER-W
 
           INSPECT IP-DATOS-USUNET REPLACING FIRST "/" BY "\"
 
           MOVE "\\" TO NOM-TER-W

           INSPECT NOM-TER-W REPLACING FIRST "                    "
                                           BY IP-DATOS-USUNET 
           INSPECT NOM-TER-W REPLACING FIRST " "
                                           BY "\"
           INSPECT NOM-TER-W REPLACING FIRST "                              "
                                            BY DIR-CONTAB-LLEGADA-W. 
           INSPECT NOM-TER-W REPLACING FIRST "                               "
                                          BY "\SAN2019\CONTROL\SC-ARCHTER.DAT".
          
       ABRIR-ARCHIVO.

           OPEN INPUT ARCHIVO-TERCEROS.
           IF OTR-STAT IS NOT = "00"
              MOVE ALL "*" TO NOMBRE-TER-LNK
              GO TO CERRAR-SESION
           END-IF

           MOVE "00"  TO SW-INVALID-ENV.

       LEER-ARCHIVO.
           MOVE COD-TERCERO-LLEGADA-W  TO COD-TERCERO

           READ ARCHIVO-TERCEROS WITH NO LOCK
                INVALID KEY     MOVE ALL "*" TO NOMBRE-TER-LNK
                NOT INVALID KEY
      *            IF  ((ACT-TER = 12) AND (COD-TER < 800000000 OR > 999999999)
      *                AND (REFER1-TER IS NOT = SPACES)) 
      *
      *                MOVE REFER1-TER TO NOMBRE-TER-LNK
      *            ELSE
      *                MOVE DESCRIP-TER TO NOMBRE-TER-LNK
      *            END-IF.
                     

           MOVE NOMBRE-TER-LNK         TO DESCRIP-TERCE-ENV.
 
       CERRAR-ARCHIVO.
          
           CLOSE ARCHIVO-TERCEROS.

       PAGINA-CONFIG.	 
           MOVE "datosrecibidos" TO COBW3-CNV-NAME
           MOVE DATOS-ENVIO      TO COBW3-CNV-VALUE
           CALL "COBW3_SET_CNV" USING COBW3
         
           MOVE "..\PAGINAS\RECIBIDOS.ASPX" TO SALIDA-HTML  
           PERFORM ABRIR-HTML.

       CERRAR-SESION.
           CALL "COBW3_FREE" USING COBW3.
           MOVE 1 TO PROGRAM-STATUS.
           EXIT PROGRAM.

              
       COPY "..\..\FUENTES\SC-WEB19.CBL".
