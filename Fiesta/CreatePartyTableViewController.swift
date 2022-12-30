//
//  CreatePartyTableViewController.swift
//  Fiesta
//
//  Created by Sanjeev RM on 19/12/22.
//

import UIKit

class CreatePartyTableViewController: UITableViewController, PeopleTableViewControllerDelegate, ItemsTableViewControllerDelegate
{
    @IBOutlet weak var noOfPeopleStepper: UIStepper!
    @IBOutlet weak var noOfPeopleLabel: UILabel!
    @IBOutlet weak var noOfItemsStepper: UIStepper!
    @IBOutlet weak var noOfItemsLabel: UILabel!
    
    @IBOutlet weak var totalAmountTextField: UITextField!
    @IBOutlet weak var taxTextField: UITextField!
    
    @IBOutlet weak var calculateButton: UIButton!
    
    var party: Party? = nil
    var people: [Person]?
    var items: [Item]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        
        updateCalculateButtonState()
    }
    
    // MARK: - Update functions
    
    func updateView()
    {
        noOfPeopleLabel.text = noOfPeopleStepper.value.formatted()
        noOfItemsLabel.text = noOfItemsStepper.value.formatted()
    }
    
    func updateCalculateButtonState()
    {
        if party == nil
        {
            calculateButton.isEnabled = false
            return
        }
        calculateButton.isEnabled = true
    }
    
    // MARK: - Action functions
    
    @IBAction func stepperValueChanged(_ sender: UIStepper)
    {
        updateView()
    }
    
    // MARK: - Segue Action functions
    
    @IBSegueAction func peoplesName(_ coder: NSCoder, sender: Any?) -> PeopleTableViewController?
    {
        let peopleVC = PeopleTableViewController(coder: coder)
        peopleVC?.delegate = self
        peopleVC?.noOfPeople = Int(noOfPeopleStepper.value)
        peopleVC?.people = self.people
        return peopleVC
    }
    
    @IBSegueAction func itemsInfo(_ coder: NSCoder, sender: Any?) -> ItemsTableViewController?
    {
        let itemsVC = ItemsTableViewController(coder: coder)
        itemsVC?.delegate = self
        itemsVC?.noOfItems = Int(noOfItemsStepper.value)
        itemsVC?.items = self.items
        return itemsVC
    }
    
    // MARK: - PeopleTbleViewConrollerDelgate functions
    
    func peopleTableViewController(_ controller: PeopleTableViewController, didUpdatePeopleNamesOf people: [Person]?)
    {
        guard let people = people else { return }
        
        self.people = people
    }
    
    // MARK: - ItemsTableViewControllerDelegate functions
    
    func itemsTableViewController(_ controller: ItemsTableViewController, didUpdateItems items: [Item]?)
    {
        guard let items = items else { return }
        
        self.items = items
    }
}
