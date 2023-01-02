//
//  CreatePartyTableViewController.swift
//  Fiesta
//
//  Created by Sanjeev RM on 19/12/22.
//

import UIKit

class CreatePartyTableViewController: UITableViewController, PeopleTableViewControllerDelegate, ItemsTableViewControllerDelegate, EachPersonItemsHadTableViewControllerDelegate
{
    @IBOutlet weak var noOfPeopleStepper: UIStepper!
    @IBOutlet weak var noOfPeopleLabel: UILabel!
    @IBOutlet weak var noOfItemsStepper: UIStepper!
    @IBOutlet weak var noOfItemsLabel: UILabel!
    
    @IBOutlet weak var totalAmountTextField: UITextField!
    @IBOutlet weak var taxTextField: UITextField!
    
    @IBOutlet weak var calculateButton: UIButton!
    
    var people: [Person]?
    var items: [Item]?
    
    /// keeps track if the items had list has been inputed or not.
    var itemsHadInputed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePeopleItemCountLabel()
        
        updateCalculateButtonState()
    }
    
    // MARK: - Update functions
    
    /// This function updates the people and item count label.
    func updatePeopleItemCountLabel()
    {
        noOfPeopleLabel.text = noOfPeopleStepper.value.formatted()
        noOfItemsLabel.text = noOfItemsStepper.value.formatted()
    }
    
    /// This function updates the Calculate button state.
    func updateCalculateButtonState()
    {
        calculateButton.isEnabled = people != nil && items != nil && totalAmountTextField.hasText && taxTextField.hasText && itemsHadInputed
    }
    
    /// This function checks if the total amount tf and tax tf if they have valid inputs.
    func checkAmountTaxTF() -> Bool
    {
        if Double(totalAmountTextField.text!) == nil || Double(taxTextField.text!) == nil
        {
            return false
        }
        return true
    }
    
    // MARK: - Action functions
    
    /// This function is fired everytime the steppers' value is changed.
    @IBAction func stepperValueChanged(_ sender: UIStepper)
    {
        updatePeopleItemCountLabel()
    }
    
    /// This function is fired evertytime the two text fields' (total amount & tax)value is changed.
    @IBAction func textFieldsValueChanged(_ sender: UITextField)
    {
        updateCalculateButtonState()
    }
    
    @IBAction func calculateButtonTapped(_ sender: UIButton)
    {
        guard checkAmountTaxTF() else
        {
            let alertVC = UIAlertController(title: "Invalid inputs for total amount or tax", message: "Please enter only digits in the total amount and tax text fields.", preferredStyle: .actionSheet)
            let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertVC.addAction(okayAction)
            present(alertVC, animated: true, completion: nil)
            return
        }
        
        performSegue(withIdentifier: "calculateSegue", sender: self)
    }
    
    /// This function is fired when the new button is tapped.
    /// This resets the whole view.
    @IBAction func newButtonTapped(_ sender: UIBarButtonItem)
    {
        self.people = nil
        self.items = nil
        self.itemsHadInputed = false
        self.noOfPeopleStepper.value = 0
        self.noOfItemsStepper.value = 0
        self.totalAmountTextField.text = ""
        self.taxTextField.text = ""
        updatePeopleItemCountLabel()
        updateCalculateButtonState()
        tableView.reloadData()
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
    
    @IBSegueAction func eachPersonHad(_ coder: NSCoder, sender: Any?) -> EachPersonItemsHadTableViewController?
    {
        let eachPersonHadVC = EachPersonItemsHadTableViewController(coder: coder)
        eachPersonHadVC?.delegate = self
        eachPersonHadVC?.people = self.people
        eachPersonHadVC?.items = self.items
        return eachPersonHadVC
    }
    
    @IBSegueAction func calculateAmountsSegueAction(_ coder: NSCoder, sender: Any?) -> CalculateTableViewController?
    {
        let calculateVC = CalculateTableViewController(coder: coder)
        calculateVC?.people = self.people
        calculateVC?.tax = Double(self.taxTextField.text!)
        calculateVC?.billTotal = Double(self.totalAmountTextField.text!)
        return calculateVC
    }
    
    // MARK: - PeopleTbleViewConrollerDelgate functions
    
    func peopleTableViewController(_ controller: PeopleTableViewController, didUpdatePeopleNamesOf people: [Person]?)
    {
        guard let people = people else { return }
        
        self.people = people
        
        updateCalculateButtonState()
    }
    
    // MARK: - ItemsTableViewControllerDelegate functions
    
    func itemsTableViewController(_ controller: ItemsTableViewController, didUpdateItems items: [Item]?)
    {
        guard let items = items else { return }
        
        self.items = items
        
        updateCalculateButtonState()
    }
    
    // MARK: - EachPersonItemsHadTableViewContollerDelegate functions
    
    func eachPersonItemsHadTableViewController(_ controller: EachPersonItemsHadTableViewController, updatedItems items: [Item]?, updatedPeople people: [Person]?)
    {
        guard let items = items, let people = people else { return }
        
        self.items = items
        self.people = people
        
        itemsHadInputed = true
        
        updateCalculateButtonState()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
