//
//  EachPersonItemHadTableViewCell.swift
//  Fiesta
//
//  Created by Sanjeev RM on 31/12/22.
//

import UIKit

class EachPersonItemHadTableViewCell: UITableViewCell
{
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var itemCountStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateItemCountLabel()
    {
        itemCountLabel.text = itemCountStepper.value.formatted()
    }
    
    func setStepperAndLabelValue(count value: Double)
    {
        itemCountStepper.value = value
        updateItemCountLabel()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper)
    {
        updateItemCountLabel()
    }
}
