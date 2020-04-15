DEFINE INPUT  PARAMETER iParams            AS LONGCHAR   NO-UNDO.    /* String input params */
DEFINE INPUT  PARAMETER iInputData         AS LONGCHAR   NO-UNDO.    /* String input data */
DEFINE OUTPUT PARAMETER oOutputPars        AS LONGCHAR   NO-UNDO.    /* String output params */
DEFINE OUTPUT PARAMETER oOutputData        AS LONGCHAR   NO-UNDO.    /* String output data */
DEFINE OUTPUT PARAMETER DATASET-HANDLE     vDatasetHandle.
DEFINE OUTPUT PARAMETER oErrMsg            AS CHARACTER  NO-UNDO.    /* Error message */

DEFINE variable iHandler as character.
function getNodeTextValue return longchar (hLeafNode as handle) forward.

{webservices/config.i}

EMPTY TEMP-TABLE WebServiceParams.
WebServiceOut = "".

iHandler = iParams.

if iInputData <> "" then
  run ParseParams (iInputData).

DO ON ERROR UNDO, LEAVE:
  RUN VALUE(iHandler). 

  oOutputPars = iHandler.
  oOutputData = WebServiceOut.

/*
output to 1.txt append.
put unformatted iHandler skip.
for each WebServiceParams:
  put unformatted WebServiceParams.pname ":" WebServiceParams.pvalue skip.
end.
define variable str as char.
str = webserviceout.
put unformatted str skip.
output close.
*/

  CATCH oneError AS Progress.Lang.SysError: 
      ASSIGN oErrMsg = oneError:GetMessage(1).
  END CATCH.  
  FINALLY:
  END FINALLY.
END.

PROCEDURE ParseParams:
  define input parameter xmldata as longchar.

  if xmldata = "" then next.

  define variable hXML        as handle no-undo.
  define variable hRoot       as handle no-undo.
  define variable hChild      as handle no-undo.
  define variable i as integer.
  define variable j as integer.
  define variable nvalue as longchar.

  CREATE X-NODEREF hRoot.

  create X-DOCUMENT hXML.
  hXML:load ('LONGCHAR', xmldata, FALSE).

  if not valid-handle(hXml) then RETURN.
  hXML:GET-DOCUMENT-ELEMENT (hRoot).
  if not valid-handle(hRoot) then RETURN.

  if hRoot:NUM-CHILDREN = 1 then
  do:
    nvalue = getNodeTextValue(hRoot).
    find first WebServiceParams where WebServiceParams.pName = hRoot:Name NO-ERROR.
    if not available WebServiceParams then
    do:
      create WebServiceParams.
      WebServiceParams.pName = hRoot:Name.
    end.
    WebServiceParams.pValue = nvalue.
/*
    Copy-LOB nvalue to WebServiceParams.pValue.
*/
    Return.
  end.

  create x-noderef hChild.

  DO i = 1 to hRoot:NUM-CHILDREN:
    hRoot:GET-CHILD (hChild, i).
    if not valid-handle(hChild) then next.
    if hChild:NAME = "#text" then next.
    nvalue = getNodeTextValue(hChild).

    find first WebServiceParams where WebServiceParams.pName = hChild:Name NO-ERROR.
    if not available WebServiceParams then
    do:
      create WebServiceParams.
      WebServiceParams.pName = hChild:Name.
    end.
    WebServiceParams.pValue = nvalue.
/*
    Copy-LOB nvalue to WebServiceParams.pValue.
*/
  END.
  DELETE OBJECT hChild.
  DELETE OBJECT hRoot.
  DELETE OBJECT hXml.
end.

function getNodeTextValue return longchar (hLeafNode as handle):
  def variable res as longchar.
  define variable hChild      as handle no-undo.

  if valid-handle(hLeafNode) then
  do:
    if hLeafNode:NUM-CHILDREN = 0 then return hLeafNode:node-value.

    create x-noderef hChild.
    hLeafNode:get-child(hChild, 1).
    if valid-handle (hChild) then
      res = hChild:node-value.
    DELETE OBJECT hChild.
    return res.
  end.
  return "".
end function.
