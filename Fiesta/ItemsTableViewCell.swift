//
//  ItemsTableViewCell.swift
//  Fiesta
//
//  Created by Sanjeev RM on 27/12/22.
//

import UIKit

class ItemsTableViewCell: UITableViewCell
{
    @IBOutlet weak var itemNameTF: UITextField!
    @IBOutlet weak var itemPriceTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
