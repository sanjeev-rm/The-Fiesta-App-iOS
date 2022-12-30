//
//  ItemsTableViewController.swift
//  Fiesta
//
//  Created by Sanjeev RM on 25/12/22.
//

import UIKit

protocol ItemsTableViewControllerDelegate
{
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
    
    func updateUpdateButtonState()
    {
        var isAnyTFEmpty = true
        for cell in tableView.visibleCells
        {
            let itemCell = cell as! ItemsTableViewCell
            
            if itemCell.itemNameTF.hasText == false || itemCell.itemPriceTF.hasText == false
            {
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
    
    func checkPriceTextFields() -> Bool
    {
        for cell in tableView.visibleCells
        {
            let itemCell = cell as! ItemsTableViewCell
            
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

    @IBAction func textFieldsValueChanged(_ sender: UITextField)
    {
        updateUpdateButtonState()
    }
    
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
    
    @IBAction func updateButtonTapped(_ sender: UIBarButtonItem)
    {
        guard checkPriceTextFields() else { return }
        
        updateAllItems()
        
        let alertVC = UIAlertController(title: "Confirm Update", message: nil, preferredStyle: .actionSheet)
        
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
