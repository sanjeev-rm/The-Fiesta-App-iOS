//
//  CreatePartyTableViewController.swift
//  Fiesta
//
//  Created by Sanjeev RM on 19/12/22.
//

import UIKit

class CreatePartyTableViewController: UITableViewController {
    
    @IBOutlet weak var noOfPeopleStepper: UIStepper!
    @IBOutlet weak var noOfPeopleLabel: UILabel!
    @IBOutlet weak var noOfItemsStepper: UIStepper!
    @IBOutlet weak var noOfItemsLabel: UILabel!
    
    @IBOutlet weak var totalAmountTextField: UITextField!
    @IBOutlet weak var taxTextField: UITextField!
    
    @IBOutlet weak var calculateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    // MARK: - Update functions
    
    func updateView()
    {
        noOfPeopleLabel.text = noOfPeopleStepper.value.formatted()
        noOfItemsLabel.text = noOfItemsStepper.value.formatted()
    }
    
    // MARK: - Action functions
    
    @IBAction func stepperValueChanged(_ sender: UIStepper)
    {
        updateView()
    }
    
    // MARK: - Table view data source
}
