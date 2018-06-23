//
//  ContentService.swift
//  YandexTranslator
//
//  Created by Soheil on 01/06/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import Foundation

class ContentService: NSObject {
	static let shared = ContentService()

	func getLanguageList(success: @escaping (_ languages: Languages?)-> Void, failure: @escaping(_ error: Error)-> Void) {
		let parameters = [
			"ui"	: "en"
		]
		BackendService.shared.callNetwork(httpMethod: .post, params: parameters, url: ApiUrl.languages, onSuccess: { jsonData in
			if let jsonData = jsonData {
				let languages = try? JSONDecoder().decode(Languages.self, from: jsonData)
				success(languages)
			}
		}) { error in
			failure(error)
		}
	}
	
	func getTranslation(_ text: String, languages: [String],  success: @escaping (_ translations: [Translation]?)-> Void, failure: @escaping(_ error: Error)-> Void) {
		
		let myGroup = DispatchGroup()
		var result = [Translation]()
		
		for lang in languages {
			myGroup.enter()
			
			let parameters = [
				"lang"	: lang,
				"text"	: text
			]
			BackendService.shared.callNetwork(httpMethod: .post, params: parameters, url: ApiUrl.translate, onSuccess: { jsonData in
				if let jsonData = jsonData {
					if let translation = try? JSONDecoder().decode(Translation.self, from: jsonData) {
						result.append(translation)
						//print(translation)
						myGroup.leave()
					}
				}
			}) { error in
				print(error)
				myGroup.leave()
			}
			
		}
		
		// Timeout for 10 seconds
//		myGroup.wait(timeout: DispatchTime(uptimeNanoseconds: 10000000000))
		
		myGroup.notify(queue: .main) {
			success(result)
		}
	}
	
	func getHistoryItem(text: String, translations: [Translation]) -> HistoryItem {
		let item = HistoryItem(text: text, translations: translations)
		return item
	}
	

}
