@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {

	// Implement this interface method
	global HTTPResponse respond(HTTPRequest req)
	{

		// Create a fake response
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');

		if (Test_TICApi.testing == 'SendToTIC')
		{
			res.setBody('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><su_fimport_draft_ws_RunResponse xmlns="http://su_fimport_draft_ws.ws.localhost/"><return>[{"ragsoc":"Società Test","numtic":"","data":"2024-05-23","totale":0,"dettaglio":"OK|Partita IVA Emittente non coincidente","num":"0/IT"}]</return></su_fimport_draft_ws_RunResponse></S:Body></S:Envelope>');
			res.setStatusCode(200);
			return res;
		} else if (Test_TICApi.testing == 'SendToTIC400')
		{
			res.setBody('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><su_fgetdett_draft_ws_RunResponse xmlns="http://su_fgetdett_draft_ws.ws.localhost/"><return>[{"ragsoc":"Società Test","numtic":"11/IT","tipdoc":"BZ","data":"29/05/2024","totale":0,"dettaglio":"[{"stato":"Evasa"}]","evasioni":"{"numtic":"5/IT","stato":"DP","tipdoc":"FA","data":"2024-05-28","dataori":"2024-05-29","numticori":"11/IT","tipdocori":"BZ"}"}]</return></su_fgetdett_draft_ws_RunResponse></S:Body></S:Envelope>');
			res.setStatusCode(400);
			return res;
		} else if (Test_TICApi.testing == 'RetrieveStatusTIC')
		{
			res.setBody('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><su_fgetdett_draft_ws_RunResponse xmlns="http://su_fgetdett_draft_ws.ws.localhost/"><return>[{"ragsoc":"Società Test","numtic":"11/IT","tipdoc":"BZ","data":"29/05/2024","totale":0,"dettaglio":"[{"stato":"Evasa"}]","evasioni":"{"numtic":"5/IT","stato":"DP","tipdoc":"FA","data":"2024-05-28","dataori":"2024-05-29","numticori":"11/IT","tipdocori":"BZ"}"}]</return></su_fgetdett_draft_ws_RunResponse></S:Body></S:Envelope>');
			res.setStatusCode(200);
			return res;
		} else if (Test_TICApi.testing == 'RetrieveStatusTIC400')
		{
			res.setBody('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><su_fgetdett_draft_ws_RunResponse xmlns="http://su_fgetdett_draft_ws.ws.localhost/"><return>[{"ragsoc":"Società Test","numtic":"11/IT","tipdoc":"BZ","data":"29/05/2024","totale":0,"dettaglio":"[{"stato":"Evasa"}]","evasioni":"{"numtic":"5/IT","stato":"DP","tipdoc":"FA","data":"2024-05-28","dataori":"2024-05-29","numticori":"11/IT","tipdocori":"BZ"}"}]</return></su_fgetdett_draft_ws_RunResponse></S:Body></S:Envelope>');
			res.setStatusCode(400);
			return res;
		} else if (Test_OpenApi.testing == 'CheckIVA200') {
			if (req.getEndpoint().contains('IT-advanced/') == true)
			{
				res.setBody('{"data": [{"taxCode": "12485671007","companyName": "OPENAPI S.P.A.","vatCode": "12485671007","address": {"registeredOffice": {"toponym": "VIALE","street": "F TOMMASO MARINETTI","streetNumber": "221","streetName": "VIALE F TOMMASO MARINETTI 221","town": "ROMA","hamlet": null,"province": "RM","zipCode": "00143","gps": {"coordinates": [12.47843,41.8071]},"townCode": "H501","region": {"code": "12","description": "LAZIO"}}},"activityStatus": "ATTIVA","reaCode": "1378273","cciaa": "RM","atecoClassification": {"ateco": {"code": "6201","description": "Produzione di software non connesso all\'edizione"}},"detailedLegalForm": {"code": "SP","description": "SOCIETA PER AZIONI"},"startDate": "2013-10-20","registrationDate": "2013-07-19","endDate": null,"pec": "openapi@legalmail.it","cessata": false,"taxCodeCeased": 1622452306,"taxCodeCeasedTimestamp": 1622452306,"gruppo_iva": {"vatGroupParticipation": false,"isVatGroupLeader": false,"registryOk": true},"sdiCode": "USAL8PV","sdiCodeTimestamp": 1622452306,"creationTimestamp": 1624358855,"lastUpdateTimestamp": 1708705000,"balanceSheets": {"last": {"year": 2022,"employees": 14,"balanceSheetDate": "2022-12-31","turnover": 4043407,"netWorth": 166491,"shareCapital": 50000},"all": [{"year": 2024,"employees": 15,"balanceSheetDate": null,"turnover": null,"netWorth": null,"shareCapital": 50000},{"year": 2023,"employees": 15,"balanceSheetDate": null,"turnover": null,"netWorth": null,"shareCapital": 50000},{"year": 2022,"employees": 14,"balanceSheetDate": "2022-12-31","turnover": 4043407,"netWorth": 166491,"shareCapital": 50000},{"year": 2021,"employees": 15,"balanceSheetDate": "2021-12-31","turnover": 4432761,"netWorth": 469366,"shareCapital": 50000},{"year": 2020,"employees": 14,"balanceSheetDate": "2020-12-31","turnover": 4192138,"netWorth": 170234,"shareCapital": 10000},{"year": 2019,"employees": 14,"balanceSheetDate": "2019-12-31","turnover": 1799587,"netWorth": 11309,"shareCapital": 10000},{"year": 2018,"employees": null,"balanceSheetDate": "2018-12-31","turnover": 1325358,"netWorth": 826,"shareCapital": null},{"year": 2017,"employees": null,"balanceSheetDate": "2017-12-31","turnover": 1120176,"netWorth": 2928,"shareCapital": null}]},"shareHolders": [{"companyName": "OPEN HOLDING S.R.L.","name": null,"surname": null,"taxCode": "16935371001","percentShare": 100}],"id": "60d1bfc731177b0a092cdfc1"}],"success": true,"message": "","error": null}');
				res.setStatusCode(200);

			} else if (req.getEndpoint().contains('province/') == true) {
				res.setBody('{"data": {"sigla": "AG","provincia": "Agrigento","superficie": 3052.59,"residenti": 446081,"num_comuni": 43,"istat": "084","regione": "Sicilia"},"success": true,"message": "","error": null}');
				res.setStatusCode(200);
			} else if (req.getEndpoint().contains('https://test.oauth.openapi.it')){
				res.setBody('{"scopes": ["GET:comparabili.openapi.it/tassonomie","GET:imprese.openapi.it/*","*:*.openapi.it/*"],"ttl": 2592000}');
				res.setStatusCode(200);
			}
			return res;
		} else if (Test_OpenApi.testing == 'CheckIVA400') {
			if (req.getEndpoint().contains('IT-advanced/') == true)			{
				res.setBody('{"data": [{"taxCode": "12485671007","companyName": "OPENAPI S.P.A.","vatCode": "12485671007","address": {"registeredOffice": {"toponym": "VIALE","street": "F TOMMASO MARINETTI","streetNumber": "221","streetName": "VIALE F TOMMASO MARINETTI 221","town": "ROMA","hamlet": null,"province": "RM","zipCode": "00143","gps": {"coordinates": [12.47843,41.8071]},"townCode": "H501","region": {"code": "12","description": "LAZIO"}}},"activityStatus": "ATTIVA","reaCode": "1378273","cciaa": "RM","atecoClassification": {"ateco": {"code": "6201","description": "Produzione di software non connesso all\'edizione"}},"detailedLegalForm": {"code": "SP","description": "SOCIETA PER AZIONI"},"startDate": "2013-10-20","registrationDate": "2013-07-19","endDate": null,"pec": "openapi@legalmail.it","cessata": false,"taxCodeCeased": 1622452306,"taxCodeCeasedTimestamp": 1622452306,"gruppo_iva": {"vatGroupParticipation": false,"isVatGroupLeader": false,"registryOk": true},"sdiCode": "USAL8PV","sdiCodeTimestamp": 1622452306,"creationTimestamp": 1624358855,"lastUpdateTimestamp": 1708705000,"balanceSheets": {"last": {"year": 2022,"employees": 14,"balanceSheetDate": "2022-12-31","turnover": 4043407,"netWorth": 166491,"shareCapital": 50000},"all": [{"year": 2024,"employees": 15,"balanceSheetDate": null,"turnover": null,"netWorth": null,"shareCapital": 50000},{"year": 2023,"employees": 15,"balanceSheetDate": null,"turnover": null,"netWorth": null,"shareCapital": 50000},{"year": 2022,"employees": 14,"balanceSheetDate": "2022-12-31","turnover": 4043407,"netWorth": 166491,"shareCapital": 50000},{"year": 2021,"employees": 15,"balanceSheetDate": "2021-12-31","turnover": 4432761,"netWorth": 469366,"shareCapital": 50000},{"year": 2020,"employees": 14,"balanceSheetDate": "2020-12-31","turnover": 4192138,"netWorth": 170234,"shareCapital": 10000},{"year": 2019,"employees": 14,"balanceSheetDate": "2019-12-31","turnover": 1799587,"netWorth": 11309,"shareCapital": 10000},{"year": 2018,"employees": null,"balanceSheetDate": "2018-12-31","turnover": 1325358,"netWorth": 826,"shareCapital": null},{"year": 2017,"employees": null,"balanceSheetDate": "2017-12-31","turnover": 1120176,"netWorth": 2928,"shareCapital": null}]},"shareHolders": [{"companyName": "OPEN HOLDING S.R.L.","name": null,"surname": null,"taxCode": "16935371001","percentShare": 100}],"id": "60d1bfc731177b0a092cdfc1"}],"success": true,"message": "","error": null}');
				res.setStatusCode(400);
			} else if (req.getEndpoint().contains('province/') == true) {
				res.setBody('{"data": {"sigla": "AG","provincia": "Agrigento","superficie": 3052.59,"residenti": 446081,"num_comuni": 43,"istat": "084","regione": "Sicilia"},"success": true,"message": "","error": null}');
				res.setStatusCode(400);
			}
			return res;
		}else if (Test_OpenApi.testing == 'CheckIVA402') {
			if (req.getEndpoint().contains('IT-advanced/') == true)
			{
				res.setBody('{"data": [{"taxCode": "12485671007","companyName": "OPENAPI S.P.A.","vatCode": "12485671007","address": {"registeredOffice": {"toponym": "VIALE","street": "F TOMMASO MARINETTI","streetNumber": "221","streetName": "VIALE F TOMMASO MARINETTI 221","town": "ROMA","hamlet": null,"province": "RM","zipCode": "00143","gps": {"coordinates": [12.47843,41.8071]},"townCode": "H501","region": {"code": "12","description": "LAZIO"}}},"activityStatus": "ATTIVA","reaCode": "1378273","cciaa": "RM","atecoClassification": {"ateco": {"code": "6201","description": "Produzione di software non connesso all\'edizione"}},"detailedLegalForm": {"code": "SP","description": "SOCIETA PER AZIONI"},"startDate": "2013-10-20","registrationDate": "2013-07-19","endDate": null,"pec": "openapi@legalmail.it","cessata": false,"taxCodeCeased": 1622452306,"taxCodeCeasedTimestamp": 1622452306,"gruppo_iva": {"vatGroupParticipation": false,"isVatGroupLeader": false,"registryOk": true},"sdiCode": "USAL8PV","sdiCodeTimestamp": 1622452306,"creationTimestamp": 1624358855,"lastUpdateTimestamp": 1708705000,"balanceSheets": {"last": {"year": 2022,"employees": 14,"balanceSheetDate": "2022-12-31","turnover": 4043407,"netWorth": 166491,"shareCapital": 50000},"all": [{"year": 2024,"employees": 15,"balanceSheetDate": null,"turnover": null,"netWorth": null,"shareCapital": 50000},{"year": 2023,"employees": 15,"balanceSheetDate": null,"turnover": null,"netWorth": null,"shareCapital": 50000},{"year": 2022,"employees": 14,"balanceSheetDate": "2022-12-31","turnover": 4043407,"netWorth": 166491,"shareCapital": 50000},{"year": 2021,"employees": 15,"balanceSheetDate": "2021-12-31","turnover": 4432761,"netWorth": 469366,"shareCapital": 50000},{"year": 2020,"employees": 14,"balanceSheetDate": "2020-12-31","turnover": 4192138,"netWorth": 170234,"shareCapital": 10000},{"year": 2019,"employees": 14,"balanceSheetDate": "2019-12-31","turnover": 1799587,"netWorth": 11309,"shareCapital": 10000},{"year": 2018,"employees": null,"balanceSheetDate": "2018-12-31","turnover": 1325358,"netWorth": 826,"shareCapital": null},{"year": 2017,"employees": null,"balanceSheetDate": "2017-12-31","turnover": 1120176,"netWorth": 2928,"shareCapital": null}]},"shareHolders": [{"companyName": "OPEN HOLDING S.R.L.","name": null,"surname": null,"taxCode": "16935371001","percentShare": 100}],"id": "60d1bfc731177b0a092cdfc1"}],"success": true,"message": "","error": null}');
				res.setStatusCode(402);

			} else if (req.getEndpoint().contains('province/') == true) {
				res.setBody('{"data": {"sigla": "AG","provincia": "Agrigento","superficie": 3052.59,"residenti": 446081,"num_comuni": 43,"istat": "084","regione": "Sicilia"},"success": true,"message": "","error": null}');
				res.setStatusCode(402);
			}
			return res;
		}else if (Test_OpenApi.testing == 'CheckIVA406') {
			if (req.getEndpoint().contains('IT-advanced/') == true)
			{
				res.setBody('{"data": [{"taxCode": "12485671007","companyName": "OPENAPI S.P.A.","vatCode": "12485671007","address": {"registeredOffice": {"toponym": "VIALE","street": "F TOMMASO MARINETTI","streetNumber": "221","streetName": "VIALE F TOMMASO MARINETTI 221","town": "ROMA","hamlet": null,"province": "RM","zipCode": "00143","gps": {"coordinates": [12.47843,41.8071]},"townCode": "H501","region": {"code": "12","description": "LAZIO"}}},"activityStatus": "ATTIVA","reaCode": "1378273","cciaa": "RM","atecoClassification": {"ateco": {"code": "6201","description": "Produzione di software non connesso all\'edizione"}},"detailedLegalForm": {"code": "SP","description": "SOCIETA PER AZIONI"},"startDate": "2013-10-20","registrationDate": "2013-07-19","endDate": null,"pec": "openapi@legalmail.it","cessata": false,"taxCodeCeased": 1622452306,"taxCodeCeasedTimestamp": 1622452306,"gruppo_iva": {"vatGroupParticipation": false,"isVatGroupLeader": false,"registryOk": true},"sdiCode": "USAL8PV","sdiCodeTimestamp": 1622452306,"creationTimestamp": 1624358855,"lastUpdateTimestamp": 1708705000,"balanceSheets": {"last": {"year": 2022,"employees": 14,"balanceSheetDate": "2022-12-31","turnover": 4043407,"netWorth": 166491,"shareCapital": 50000},"all": [{"year": 2024,"employees": 15,"balanceSheetDate": null,"turnover": null,"netWorth": null,"shareCapital": 50000},{"year": 2023,"employees": 15,"balanceSheetDate": null,"turnover": null,"netWorth": null,"shareCapital": 50000},{"year": 2022,"employees": 14,"balanceSheetDate": "2022-12-31","turnover": 4043407,"netWorth": 166491,"shareCapital": 50000},{"year": 2021,"employees": 15,"balanceSheetDate": "2021-12-31","turnover": 4432761,"netWorth": 469366,"shareCapital": 50000},{"year": 2020,"employees": 14,"balanceSheetDate": "2020-12-31","turnover": 4192138,"netWorth": 170234,"shareCapital": 10000},{"year": 2019,"employees": 14,"balanceSheetDate": "2019-12-31","turnover": 1799587,"netWorth": 11309,"shareCapital": 10000},{"year": 2018,"employees": null,"balanceSheetDate": "2018-12-31","turnover": 1325358,"netWorth": 826,"shareCapital": null},{"year": 2017,"employees": null,"balanceSheetDate": "2017-12-31","turnover": 1120176,"netWorth": 2928,"shareCapital": null}]},"shareHolders": [{"companyName": "OPEN HOLDING S.R.L.","name": null,"surname": null,"taxCode": "16935371001","percentShare": 100}],"id": "60d1bfc731177b0a092cdfc1"}],"success": true,"message": "","error": null}');
				res.setStatusCode(406);

			} else if (req.getEndpoint().contains('province/') == true) {
				res.setBody('{"data": {"sigla": "AG","provincia": "Agrigento","superficie": 3052.59,"residenti": 446081,"num_comuni": 43,"istat": "084","regione": "Sicilia"},"success": true,"message": "","error": null}');
				res.setStatusCode(406);
			}
			return res;
		}else {
			res.setStatusCode(200);
			return res;
		}
	}
}