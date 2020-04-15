DEFINE TEMP-TABLE ttData NO-UNDO  LIKE clients.
DEFINE DATASET dsResult FOR ttData.

DEFINE INPUT  PARAMETER iInputPars AS LONGCHAR   NO-UNDO.
DEFINE INPUT  PARAMETER iInputData AS LONGCHAR   NO-UNDO.
DEFINE OUTPUT PARAMETER oOutputPars AS LONGCHAR   NO-UNDO.
DEFINE OUTPUT PARAMETER oOutputData AS LONGCHAR   NO-UNDO.
DEFINE OUTPUT PARAMETER DATASET FOR dsResult.
DEFINE OUTPUT PARAMETER oErrMsg AS CHARACTER   NO-UNDO.

/* ************************  Function Prototypes ********************** */
FUNCTION GetParVal RETURNS CHARACTER
  ( /* parameter-definitions */
      iParName AS CHAR,
      iNameValuePairStr AS LONGCHAR,
      iDelimiter AS CHAR )  FORWARD.

RUN processRequest.
DATASET dsResult:WRITE-XML("file","temp/dsResult.xml",true).
ASSIGN oOutputPars = iInputPars.
PROCEDURE processRequest :
    DEFINE VARIABLE vNumCustomersToPull as integer NO-UNDO.
    DEFINE VARIABLE tablename AS character  NO-UNDO.
    DEFINE VARIABLE vCnt1 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE vInputPars AS CHARACTER   NO-UNDO.


    vInputPars = STRING(iInputPars).
    vNumCustomersToPull = 10.
    tablename  = GetParVal("tablename",vInputPars,"&").
    FOR EACH clients NO-LOCK:
        ASSIGN vCnt1 = vCnt1 + 1.
        CREATE ttData.
        BUFFER-COPY clients TO ttData.
        IF vNumCustomersToPull > 0 AND vCnt1 >= vNumCustomersToPull
            THEN LEAVE.
    END.
END PROCEDURE.

/* ************************  Function Implementations ***************** */
FUNCTION GetParVal RETURNS CHARACTER (
      iParName AS CHAR,
      iNameValuePairStr AS LONGCHAR,
      iDelimiter AS CHAR ) :

  DEFINE VARIABLE vParVal AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE i AS INTEGER     NO-UNDO.
  DEFINE VARIABLE j AS INTEGER     NO-UNDO.
  DEFINE VARIABLE vEntry AS CHARACTER   NO-UNDO.
  DO i = 1 TO NUM-ENTRIES(iNameValuePairStr,iDelimiter):
      ASSIGN vEntry = ENTRY(i,iNameValuePairStr,iDelimiter )
             j = INDEX(vEntry,"=").
      IF j > 0 AND TRIM(SUBSTR(vEntry,1,j - 1)) EQ iParName THEN
      DO:
          ASSIGN vParVal = TRIM(SUBSTR(vEntry,j + 1)).
          LEAVE.
      END.

  END.
  RETURN vParVal.   /* Function return value. */
END FUNCTION.
