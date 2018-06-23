//
//  HistoryViewController.swift
//  YandexTranslator
//
//  Created by Soheil on 23/06/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import UIKit

protocol HistoryViewControllerDelegate: class {
	func dataChanged(historyItem: HistoryItem)
}

class HistoryViewController: UITableViewController {
	
	var history = [HistoryItem]()
	weak var delegate: HistoryViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return history.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
		
		let historyItem = history[indexPath.row]
		cell.textLabel?.text = historyItem.text
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		print(history[indexPath.row])
		delegate?.dataChanged(historyItem: history[indexPath.row])
		dismiss(animated: true, completion: nil)
	}

}
