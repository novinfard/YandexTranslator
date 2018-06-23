//
//  ViewController.swift
//  YandexTranslator
//
//  Created by Soheil on 22/06/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
	
	var languages: Languages?
	var translations: [Translation]?
	var selectedDir: String?
	var history = [HistoryItem]()
	
	var languagePicker: UIPickerView!
	
	@IBOutlet weak var translationText: UITextView!
	@IBOutlet weak var languageField: UITextField!
	@IBOutlet weak var tableview: UITableView!
	

	override func viewDidLoad() {
		super.viewDidLoad()
		
		startLoader()
		configTranslationText()
		configTableview()
		getLanguageList()
	}
	
	func getLanguageList() {
		ContentService.shared.getLanguageList(success: { item in
			self.languages = item
			
			DispatchQueue.main.async {
				self.configTranslatePicker()
				self.endLoader()
			}
		}) { _ in
			print("Error getting languages")
		}
	}
	
	func getTranslation(text: String, dir: [String]) {
		startLoader()
		ContentService.shared.getTranslation(text, languages: dir, success: { items in
			self.translations = items
			
			if let items = items {
				self.history.append(ContentService.shared.getHistoryItem(text: text, translations: items))
				print(self.history)
			}
			
			DispatchQueue.main.async {
				self.tableview.reloadData()
				self.endLoader()
			}
			
		}) { _ in
			print("Error getting translations")
		}
	}

	func startLoader() {
		let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
		loadingNotification.mode = MBProgressHUDMode.indeterminate
		loadingNotification.label.text = "Loading"
	}
	
	func endLoader() {
		MBProgressHUD.hide(for: self.view, animated: true)
	}
	
	func configTranslationText() {
		translationText.layer.borderColor = UIColor.brown.cgColor;
		translationText.layer.borderWidth = 1.0;
		translationText.layer.cornerRadius = 5.0;
		translationText.textColor = UIColor.lightGray
		
		translationText.delegate = self
	}
	
	func configTableview() {
		self.tableview.delegate = self
		self.tableview.dataSource = self
	}
	
	func configTranslatePicker() {
		let frame = self.view.frame
		let pickerFrame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: 216)
		languagePicker = UIPickerView(frame: pickerFrame)
		languagePicker.isHidden = false
		languagePicker.backgroundColor = UIColor.white
		languagePicker.dataSource = self
		languagePicker.delegate = self
		languageField.inputView = languagePicker
		languageField.delegate = self
		
		// add toolbar
		let toolBar = UIToolbar()
		toolBar.barStyle = UIBarStyle.default
		toolBar.isTranslucent = true
		toolBar.tintColor = UIColor.black
		toolBar.sizeToFit()
		
		let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.donePicker))
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
		toolBar.isUserInteractionEnabled = true
		languageField.inputAccessoryView = toolBar
		languageField.text = "All Languages"
	}
	
	@IBAction func translatePressed(_ sender: Any) {
		languagePickerEndEditing()
		translationText.endEditing(true)
		
		guard translationText.text.count > 3 else {
			let alert = UIAlertController(title: "Too short", message: "Please enter longer text to translate which at least contains 3 characters", preferredStyle:.alert)
			
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction!) in
				self.navigationController?.popViewController(animated: true)
			})
			present(alert, animated: true, completion: nil)
			return
		}
		let text = translationText.text!
	
		if languagePicker.selectedRow(inComponent: 0) > 0 {
			if let dir = selectedDir {
				self.getTranslation(text: text, dir: [dir])
			}
		} else {
			if let dirs = languages?.dirs {
				self.getTranslation(text: text, dir: dirs)
			}
		}
	}
	
	@IBAction func backgroundPressed(_ sender: Any) {
		translationText.endEditing(true)
	}
	
	@objc func donePicker() {
		languageField.endEditing(true)
	}
	
	func getLanguage(fromDir dir: String) -> String {
		let startIndex = dir.index(dir.startIndex, offsetBy: 3)
		let langCode = String(dir[startIndex...])
		if languages?.langs.keys.contains(langCode) ?? false {
			return (languages?.langs[langCode])!
		} else {
			return langCode
		}
	}
	
	func languagePickerEndEditing() {
		let row  = languagePicker.selectedRow(inComponent: 0)
		if row == 0 {
			languageField.text = "All Languages"
			selectedDir = nil
		} else {
			selectedDir = languages?.dirs[row-1]

			if let dir = selectedDir {
				let startIndex = dir.index(dir.startIndex, offsetBy: 3)
				let langCode = String(dir[startIndex...])
				if languages?.langs.keys.contains(langCode) ?? false {
					languageField.text =  languages?.langs[langCode]
				} else {
					languageField.text =  langCode
				}
			}
		}
		languageField.endEditing(true)
	}
}

extension ViewController: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView == languagePicker {
			if let count = languages?.dirs.count {
				return count + 1
			} else {
				return 1
			}
		}
		return 0
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView == languagePicker {
			var title = ""
			if row == 0 {
				title = "All Languages"
				languageField.text = title
				selectedDir = nil
			} else {
				selectedDir = languages?.dirs[row-1]
				
				if let dir = selectedDir {
					let startIndex = dir.index(dir.startIndex, offsetBy: 3)
					let langCode = String(dir[startIndex...])
					if languages?.langs.keys.contains(langCode) ?? false {
						title = (languages?.langs[langCode])!
						languageField.text =  title
					} else {
						title = langCode
						languageField.text =  title
					}
				}
			}
			return title
		}
		return ""
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if pickerView == languagePicker {
			if row == 0 {
				languageField.text = "All Languages"
				selectedDir = nil
			} else {
				selectedDir = languages?.dirs[row-1]
				
				if let dir = selectedDir {
					let startIndex = dir.index(dir.startIndex, offsetBy: 3)
					let langCode = String(dir[startIndex...])
					if languages?.langs.keys.contains(langCode) ?? false {
						languageField.text =  languages?.langs[langCode]
					} else {
						languageField.text =  langCode
					}
				}
			}
		}
	}
}

extension ViewController: UITextViewDelegate {
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == UIColor.lightGray {
			textView.text = nil
			textView.textColor = UIColor.black
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = "Enter your text to translate ..."
			textView.textColor = UIColor.lightGray
		}
	}
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return translations?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "translationCell", for: indexPath) as! TranslationTableViewCell
		
		if let translations = translations {
			let translation = translations[indexPath.row]
			
			cell.translationLabel.text = translation.text.joined(separator: " ")
			cell.languageLabel.text = getLanguage(fromDir: translation.lang)
		}
		
		
		return cell
	}
}

extension ViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
}


