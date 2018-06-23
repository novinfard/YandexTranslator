//
//  BackendService.swift
//  YandexTranslator
//
//  Created by Soheil on 30/05/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import Foundation
import Alamofire

enum HttpRequestType: String {
	case HttpRequestGet = "Get"
	case HttpRequestPost = "Post"
}

struct ApiUrl {
	static let languages = "https://translate.yandex.net/api/v1.5/tr.json/getLangs"
	static let translate = "https://translate.yandex.net/api/v1.5/tr.json/translate"
}

let ApiKey = "trnsl.1.1.20180618T160416Z.16b70a0930cc1557.e167183e5b19d460d8f212247551f90b60128a41"

class BackendService: NSObject {
	static let shared = BackendService()
	
	func callNetwork( httpMethod: HTTPMethod ,params: Dictionary<String, Any>?,url: String ,onSuccess success:@escaping (_ data: Data?)->Void, onfailure failure:@escaping (_ error :Error)->Void ) -> Void {
		var requestedParams = params
		// add api key to requests
		if requestedParams != nil {
			requestedParams!["key"] = ApiKey
		}
		
		Alamofire.request(url, method: .post, parameters: requestedParams).responseJSON { response in
			// error handling
			guard case let .failure(error) = response.result else {
				// successful
				// print(response)
				success(response.data)
				return
			}
			if let error = error as? AFError {
				failure(error)
			} else if let error = error as? URLError {
				failure(error)
			}
		}
	}
	
}
