//
//  PeopleTableViewCell.swift
//  Fiesta
//
//  Created by Sanjeev RM on 26/12/22.
//

import UIKit

class PeopleTableViewCell: UITableViewCell
{
    @IBOutlet weak var nameTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
