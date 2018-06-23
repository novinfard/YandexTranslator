//
//  TranslationTableViewCell.swift
//  YandexTranslator
//
//  Created by Soheil on 23/06/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import UIKit

class TranslationTableViewCell: UITableViewCell {

	@IBOutlet weak var translationLabel: UILabel!
	@IBOutlet weak var languageLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
