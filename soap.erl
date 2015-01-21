-module(soap).

-export([lang_lat_service/1, test/0]).

-define(URL,
	"http://graphical.weather.gov/xml/SOAP_server/"
	"ndfdXMLserver.php").

-define(HOST,
	"http://graphical.weather.gov/xml/SOAP_server/"
	"ndfdXMLserver.php").

lang_lat_service(ZipCode) ->
    io:format("Data is ~p~n", [ZipCode]),
    RequestPayload = getData(ZipCode),
    io:format("Data is ~p~n", [RequestPayload]),
    make_call(RequestPayload),
    ok.

make_call(Data) ->
    inets:start(),
    {ok, Result} = httpc:request(post,
				 {?URL,
				  [{"SOAPAction",
				    "http://graphical.weather.gov/xml/DWMLgen/wsdl"
				    "/ndfdXML.wsdl#LatLonListZipCode"}],
				  "text/xml", Data},
				 [{timeout, 5000}], [{body_format, binary}]),
    io:format("Soap Response is ~p~n", [Result]),
    Result.

getData(ZipCode) ->
    XmlData =
	" <soapenv:Envelope xmlns:xsi=\"http://www.w3."
	"org/2001/XMLSchema-instance\" xmlns:xsd=\"htt"
	"p://www.w3.org/2001/XMLSchema\" xmlns:soapenv"
	"=\"http://schemas.xmlsoap.org/soap/envelope/\" "
	"xmlns:ndf=\"http://graphical.weather.gov/xml/"
	"DWMLgen/wsdl/ndfdXML.wsdl\">   <soapenv:Heade"
	"r/>   <soapenv:Body>      <ndf:LatLonListZipC"
	"ode soapenv:encodingStyle=\"http://schemas.xm"
	"lsoap.org/soap/encoding/\">         "
	"<zipCodeList xsi:type=\"dwml:zipCodeListType\" "
	"xmlns:dwml=\"http://graphical.weather.gov/xml"
	"/DWMLgen/schema/DWML.xsd\">"
	  ++
	  ZipCode ++
	    "</zipCodeList>      </ndf:LatLonListZipCode> "
	    "  </soapenv:Body></soapenv:Envelope>",
    XmlData.

test() -> soap:lang_lat_service("12201").
