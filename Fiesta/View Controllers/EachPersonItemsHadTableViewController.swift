//
//  EachPersonItemsHadTableViewController.swift
//  Fiesta
//
//  Created by Sanjeev RM on 31/12/22.
//

import UIKit

protocol EachPersonItemsHadTableViewControllerDelegate
{
    /// This function contains the updated items and people array.
    func eachPersonItemsHadTableViewController(_ controller: EachPersonItemsHadTableViewController, updatedItems items: [Item]?, updatedPeople people: [Person]?)
}

class EachPersonItemsHadTableViewController: UITableViewController
{
    var delegate: EachPersonItemsHadTableViewControllerDelegate?
    
    var people: [Person]?
    var items: [Item]?
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.isEnabled = !(people == nil || items == nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Update functions
    
    /// This function is for when the done button is tapped.
    /// This function gets the values from the cells and saves it in the properties.
    func updatePeopleAndItems()
    {
        for cell in tableView.visibleCells
        {
            // Getting the cell as my custom table view cell.
            let itemCountCell = cell as! EachPersonItemHadTableViewCell
            
            // Making sure the items and people array is not nil.
            if let indexPath = tableView.indexPath(for: cell), items != nil && people != nil
            {
                // Updating the item's count.
                self.items![indexPath.row].count = itemCountCell.itemCountStepper.value
                
                // Getting the person and the item copys or instances.
                var person = self.people![indexPath.section]
                let item = self.items![indexPath.row]
                
                if person.itemsHad == nil
                {
                    // This means this is the first initialization of the array so creating and setting the array.
                    person.itemsHad = [item]
                }
                else if indexPath.row < person.itemsHad!.count
                {
                    // This means the array is already there so we are just updating the count.
                    person.itemsHad![indexPath.row] = item
                }
                else
                {
                    // This means the array is created but this is a new item so appending it.
                    person.itemsHad!.append(item)
                }
                
                // Making these changes to the original person in the people array.
                self.people![indexPath.section] = person
            }
        }
    }
    
    func checkItemCountTF() -> Bool
    {
        for cell in tableView.visibleCells
        {
            let itemCell = cell as! EachPersonItemHadTableViewCell
            
            if itemCell.itemCountTF.text != nil && Double(itemCell.itemCountTF.text!) == nil
            {
                let alertVC = UIAlertController(title: "Invalid Inputs", message: "Invalid inputs for items count text fields. Please enter valid decimal inputs.", preferredStyle: .actionSheet)
                let okayAction = UIAlertAction(title: "Okay", style: .cancel)
                alertVC.addAction(okayAction)
                present(alertVC, animated: true)
                return false
            }
        }
        return true
    }
    
    // MARK: - Action functions
    
    /// This function is fired when the done button is tapped.
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem)
    {
        guard checkItemCountTF() else { return }
        
        updatePeopleAndItems()
        
        let alertVC = UIAlertController(title: "Confirm", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let updateAction = UIAlertAction(title: "Update", style: .default) { action in
            self.delegate?.eachPersonItemsHadTableViewController(self, updatedItems: self.items, updatedPeople: self.people)
            self.doneButton.isEnabled = false
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(updateAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func stepperTFValueChanged(_ sender: Any)
    {
        if doneButton.isEnabled == false
        {
            doneButton.isEnabled = true
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard let peopleCount = people?.count else { return 0 }
        return peopleCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let itemsCount = items?.count else { return 0 }
        return itemsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCountCell", for: indexPath) as! EachPersonItemHadTableViewCell

        guard let items = items, let people = people else { return cell }
        
        let item = items[indexPath.row]
        cell.itemName.text = item.name
        
        let person = people[indexPath.section]
        
        // This condition indexPath.row < personItemsHad.count is put for situation when the user increases an item then that should reflect here also but, it's not already in the itemsHad list so we can't give it the default value we have to set it 0 initially.
        if let personItemsHad = person.itemsHad, indexPath.row < personItemsHad.count, let itemCount = personItemsHad[indexPath.row].count
        {
            cell.setStepperAndTFValue(count: itemCount)
        }
        else
        {
            cell.setStepperAndTFValue(count: 0)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        guard let people = people else { return nil }
        return "\(people[section].name) had"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
