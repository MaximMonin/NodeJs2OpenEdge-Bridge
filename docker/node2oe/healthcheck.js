const http = require('http');
const options = {
    host: '127.0.0.1',
    port: 3000,
    timeout: 2000
};
var soap = require('soap');
var urlendpoint = process.env.UrlEndPoint;
var url = urlendpoint + '/wsdl?TargetUri=OpenedgeBridge';
var args = { iHandler: "healthcheck", iInputPars: "", iInputBase64: "", iIncludeMetaSchema: 1 };

const healthCheck = http.request(options, (res) => {
    if (res.statusCode == 200) 
    {
      soap.createClient(url, {endpoint: urlendpoint}, function(err, client) 
      {
        if (err) {
          console.log("Connect to webservice ERROR: "+err);
          process.exit(1);
        }
        else 
        {
          client.OpenedgeBridge(args, function(err, result) 
          {
            if (err) {
               console.log("WebService Query Error: "+err);
               process.exit(1);
            }
            else {
              console.log("Webservice OK");
              process.exit(0);
            }
          });
        }
      });
    }
    else {
        process.exit(1);
    }
});

healthCheck.on('error', function (err) {
    console.error('ERROR');
    process.exit(1);
});

healthCheck.end();

