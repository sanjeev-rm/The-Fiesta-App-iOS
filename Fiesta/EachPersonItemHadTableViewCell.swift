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
    @IBOutlet weak var itemCountTF: UITextField!
    @IBOutlet weak var itemCountStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateItemCountTF()
    {
        itemCountTF.text = itemCountStepper.value.formatted()
    }
    
    func updateItemCountStepperValue()
    {
        guard let tfText = itemCountTF.text, let itemCount = Double(tfText) else
        {
            itemCountStepper.value = 0
            return
        }
        
        itemCountStepper.value = itemCount
    }
    
    func setStepperAndTFValue(count value: Double)
    {
        itemCountStepper.value = value
        updateItemCountTF()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper)
    {
        updateItemCountTF()
    }
    
    @IBAction func itemCountTFTextChanged(_ sender: UITextField)
    {
        updateItemCountStepperValue()
    }
}
