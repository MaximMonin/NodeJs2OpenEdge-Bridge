&IF DEFINED(WEBSERVICE_CALL) = 0 &THEN
&GLOBAL-DEFINE WEBSERVICE_CALL "YES"
define new shared variable WebServiceOut as longchar NO-UNDO.
define new shared stream WebStream.

define new shared temp-table WebServiceParams NO-UNDO
  field pName as character
  field pValue as character
  index i0 pname.

&ENDIF
