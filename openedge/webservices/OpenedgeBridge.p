DEFINE INPUT  PARAMETER iHandler           AS CHARACTER  NO-UNDO.    /* Procedure.p to call */
DEFINE INPUT  PARAMETER iInputPars         AS LONGCHAR   NO-UNDO.    /* String input params */
DEFINE INPUT  PARAMETER iInputBase64       AS LONGCHAR   NO-UNDO.    /* String base64 input params */
DEFINE INPUT  PARAMETER iIncludeMetaSchema AS LOGICAL    NO-UNDO.    /* Include Output Dartaset Metaschema yes/no */
DEFINE OUTPUT PARAMETER oOutputPars        AS LONGCHAR   NO-UNDO.    /* OUTPUT string params */
DEFINE OUTPUT PARAMETER oOutputBase64      AS LONGCHAR   NO-UNDO.    /* OUTPUT base64 params */
DEFINE OUTPUT PARAMETER oDataset           AS LONGCHAR   NO-UNDO.    /* OUTPUT dataset base64 xml prodataset */
DEFINE OUTPUT PARAMETER oErrMsg            AS CHARACTER  NO-UNDO.    /* Error message */

DEFINE VARIABLE temp1 AS MEMPTR NO-UNDO.
DEFINE VARIABLE temp2 AS MEMPTR NO-UNDO.
DEFINE VARIABLE temp3 AS MEMPTR NO-UNDO.

DEFINE VARIABLE iInputData         AS LONGCHAR  NO-UNDO.
DEFINE VARIABLE oOutputData        AS LONGCHAR  NO-UNDO.
DEFINE VARIABLE vDatasetHandle     AS HANDLE    NO-UNDO.

if iInputBase64 <> "" then
do:
  temp1 = BASE64-DECODE(iInputBase64).
  COPY-LOB from temp1 to iInputData.
  set-size(temp1) = 0.
end.

DO ON ERROR UNDO, LEAVE:
  RUN VALUE(iHandler) (
      INPUT iInputPars,
      INPUT iInputData,
      OUTPUT oOutputPars,
      OUTPUT oOutputData,
      OUTPUT DATASET-HANDLE vDatasetHandle,
      OUTPUT oErrMsg).

  if oOutputData <> "" then
  do:
    COPY-LOB FROM oOutputData to temp2.
    oOutputBase64 = BASE64-ENCODE(temp2).
    set-size(temp2) = 0.
  end.

  IF VALID-HANDLE(vDatasetHandle) THEN
  DO:
    vDatasetHandle:WRITE-XML("LONGCHAR",oDataset,TRUE,?,?,iIncludeMetaSchema).
    COPY-LOB FROM oDataset to temp3.
    oDataset = BASE64-ENCODE(temp3).
    set-size(temp3) = 0.
  END.

  CATCH oneError AS Progress.Lang.SysError: 
      ASSIGN oErrMsg = oneError:GetMessage(1).
  END CATCH.  
  FINALLY:
  END FINALLY.
END.

