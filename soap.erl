-module(soap).
-export([lang_lat_service/1]).
-define(URL,"http://www.weather.gov/forecasts/xml/SOAP_server/ndfdXMLserver.php").
-define(HOST,"http://www.weather.gov").


lang_lat_service(ZipCode) ->
    io:format("Data is ~p~n", [ZipCode]),
    RequestPayload = getData(ZipCode), 
    io:format("Data is ~p~n", [RequestPayload]),
    make_call(RequestPayload),
    ok.

make_call(Data)->
   inets:start(), 
   {ok, Result} =  http:request( post, {?URL, [{"Host" , ?HOST}, {"SOAPAction", "http://www.weather.gov/forecasts/xml/DWMLgen/wsdl/ndfdXML.wsdl#LatLonListZipCode"}], "text/xml", Data}, [ {timeout, 5000} ], [{body_format, binary}]),    io:format("Soap Response is ~p~n", [Result]),
     Result.


process_request(Result)->
%%    case {ok, Result} ->
	%%    io:format("Soap Response is ~p~n", [Result]);	     
	  %%  {error, Reason}  -> 
	   %% io:format("Error is ~p~n", [Reason])
  %%  end.
ok.

getData(ZipCode)->
    XmlData = " <soapenv:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ndf=\"http://www.weather.gov/forecasts/xml/DWMLgen/wsdl/ndfdXML.wsdl\">   <soapenv:Header/>   <soapenv:Body>      <ndf:LatLonListZipCode soapenv:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">         <zipCodeList xsi:type=\"dwml:zipCodeListType\" xmlns:dwml=\"http://www.weather.gov/forecasts/xml/DWMLgen/schema/DWML.xsd\">"
	++ ZipCode 
	++ "</zipCodeList>      </ndf:LatLonListZipCode>   </soapenv:Body></soapenv:Envelope>".

