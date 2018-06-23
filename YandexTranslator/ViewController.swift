//
//  ViewController.swift
//  YandexTranslator
//
//  Created by Soheil on 22/06/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var languages: Languages?
	var translations: [Translation]?

	override func viewDidLoad() {
		super.viewDidLoad()
		getLanguageList()
//		getTranslation()
	}
	
	func getTranslation(text: String, dir: [String]) {
		ContentService.shared.getTranslation(text, languages: dir, success: { items in
			self.translations = items
			print(items!)
			
			//			DispatchQueue.main.async {
			//				self.tableView.reloadData()
			//			}
			
		}) { _ in
			print("Error getting translations")
		}
	}
	
	// MARK: Private Methods
	func getLanguageList() {
		ContentService.shared.getLanguageList(success: { item in
			self.languages = item
			if let dirs = item?.dirs {
				self.getTranslation(text: "This is apple", dir: dirs)
			}
		}) { _ in
			print("Error getting languages")
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

