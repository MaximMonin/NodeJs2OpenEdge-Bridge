define shared variable WebServiceOut as longchar NO-UNDO.
define shared temp-table WebServiceParams NO-UNDO
  field pName as character
  field pValue as character
  index i0 pname.

FUNCTION get-value RETURNS CHARACTER (INPUT iparam AS CHARACTER) FORWARD. 
FUNCTION get-valueEx RETURNS longchar (INPUT iparam AS CHARACTER) FORWARD. 
FUNCTION get-long-value RETURNS longchar (INPUT iparam AS CHARACTER) FORWARD. 
FUNCTION get-field RETURNS longchar (INPUT iparam AS CHARACTER) FORWARD. 

FUNCTION get-value RETURNS CHARACTER ( INPUT iparam AS CHARACTER).
  find first WebServiceParams where WebServiceParams.pName = iparam NO-ERROR.
  if available WebServiceParams then
    RETURN WebServiceParams.pvalue.
  RETURN "".
END.
FUNCTION get-valueEx RETURNS longchar ( INPUT iparam AS CHARACTER).
  find first WebServiceParams where WebServiceParams.pName = iparam NO-ERROR.
  if available WebServiceParams then
    RETURN WebServiceParams.pvalue.
  RETURN "".
END.
FUNCTION get-long-value RETURNS longchar ( INPUT iparam AS CHARACTER).
  find first WebServiceParams where WebServiceParams.pName = iparam NO-ERROR.
  if available WebServiceParams then
    RETURN WebServiceParams.pvalue.
  RETURN "".
END.

FUNCTION get-field RETURNS longchar ( INPUT iparam AS CHARACTER).
  RETURN "".
END.
