//
//  ParserScheme.swift
//  YandexTranslator
//
//  Created by Soheil on 01/06/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import Foundation

struct Languages: Codable {
	let dirs: [String]
	let langs: [String: String]
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		langs = try values.decode([String: String].self, forKey: .langs)
		
		let tempDirs = try values.decode([String].self, forKey: .dirs)
		dirs = tempDirs.filter {$0.hasPrefix("en-")}
	}
}

struct Translation: Codable {
	let code: Int
	let lang: String
	let text: [String]
}


