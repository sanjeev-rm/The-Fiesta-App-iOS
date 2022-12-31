//
//  ItemsTableViewController.swift
//  Fiesta
//
//  Created by Sanjeev RM on 25/12/22.
//

import UIKit

protocol ItemsTableViewControllerDelegate
{
    /// This function contains the updated items.
    func itemsTableViewController(_ controller: ItemsTableViewController, didUpdateItems items: [Item]?)
}

class ItemsTableViewController: UITableViewController
{
    var delegate: ItemsTableViewControllerDelegate?
    
    var noOfItems: Int?
    var items: [Item]?
    
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUpdateButtonState()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Update functions
    
    /// This function updates the state of the update button.
    func updateUpdateButtonState()
    {
        // Initially taking true, yes assuming atleast one TF is empty.
        var isAnyTFEmpty = true
        for cell in tableView.visibleCells
        {
            let itemCell = cell as! ItemsTableViewCell
            
            if itemCell.itemNameTF.hasText == false || itemCell.itemPriceTF.hasText == false
            {
                // This means actually one TF is empty so breaking the loop.
                isAnyTFEmpty = true
                break
            }
            else
            {
                isAnyTFEmpty = false
            }
        }
        
        updateButton.isEnabled = !isAnyTFEmpty
    }
    
    /// This function updates all the item text fields.
    func updateAllItems()
    {
        for cell in tableView.visibleCells
        {
            let itemCell = cell as! ItemsTableViewCell
            let name = itemCell.itemNameTF.text!
            let price = Double(itemCell.itemPriceTF.text!)!
            
            let item = Item(name: name, price: price)
            
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            if let items = self.items
            {
                if tableView.indexPath(for: cell)!.row < items.count
                {
                    self.items![indexPath.row] = item
                }
                else
                {
                    self.items!.append(item)
                }
            }
            else
            {
                self.items = [item]
            }
        }
    }
    
    /// This function checks the price text fields if they have an valid value.
    /// A value is invalid if any caharacters other than 0-9 or '.'  is inputed.
    /// - returns: Bool -> true if all are valid, false if any is invalid.
    func checkPriceTextFields() -> Bool
    {
        for cell in tableView.visibleCells
        {
            let itemCell = cell as! ItemsTableViewCell
            
            // Invalid if any value is unable to be converted to Double type.
            if Double(itemCell.itemPriceTF.text!) == nil
            {
                let alertVC = UIAlertController(title: "Invalid Inputs For Price", message: "Please enter only digits in the price text fields.", preferredStyle: .actionSheet)
                let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alertVC.addAction(okayAction)
                present(alertVC, animated: true, completion: nil)
                
                return false
            }
        }
        return true
    }
    
    // MARK: - Action functions
    
    /// This function is fired everytime the text fields' value is changed.
    @IBAction func textFieldsValueChanged(_ sender: UITextField)
    {
        updateUpdateButtonState()
    }
    
    /// This function is fired when the Fill deault names button is tapped.
    /// It fills the default names in for the item names.
    @IBAction func fillDefaultNamesButtonTapped(_ sender: UIBarButtonItem)
    {
        for cell in tableView.visibleCells
        {
            let itemCell = cell as! ItemsTableViewCell
            
            if itemCell.itemNameTF.hasText == false
            {
                itemCell.itemNameTF.text = "Item \(tableView.indexPath(for: cell)!.row + 1)"
            }
        }
        
        updateUpdateButtonState()
    }
    
    /// This function is fired when the update butto is tapped.
    /// It asks two options either to confirm update of cancel.
    @IBAction func updateButtonTapped(_ sender: UIBarButtonItem)
    {
        guard checkPriceTextFields() else { return }
        
        updateAllItems()
        
        let alertVC = UIAlertController(title: "Confirm Update", message: "Confirm items update.", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let updateAction = UIAlertAction(title: "Update", style: .default) { action in
            self.delegate?.itemsTableViewController(self, didUpdateItems: self.items)
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(updateAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let noOfItems = noOfItems
        {
            return noOfItems
        }
        return 0
    }

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemsTableViewCell
       
       // If indexPath.row < items.count is false that means that a new item has been added so we need to get the new info from the user, so run the else block.
       if let items = items, indexPath.row < items.count
       {
           cell.itemNameTF.text = items[indexPath.row].name
           cell.itemPriceTF.text = items[indexPath.row].price.formatted()
       }
       else
       {
           cell.itemNameTF.placeholder = "Item\(indexPath.row + 1) Name"
           cell.itemPriceTF.placeholder = "Price"
       }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
