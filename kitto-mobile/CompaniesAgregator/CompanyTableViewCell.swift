//
//  CompanyTableViewCell.swift
//  kitto-mobile
//
//  Created by Alexander Tarasov on 25/06/2019.
//  Copyright © 2019 Alexander Tarasov. All rights reserved.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {
    @IBOutlet weak var companyNameLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
