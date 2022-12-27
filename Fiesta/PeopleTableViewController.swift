//
//  PeopleTableViewController.swift
//  Fiesta
//
//  Created by Sanjeev RM on 25/12/22.
//

import UIKit

protocol PeopleTableViewControllerDelegate
{
    func peopleTableViewController(_ controller: PeopleTableViewController, didUpdatePeopleNamesOf people: [Person]?)
}

class PeopleTableViewController: UITableViewController
{
    var delegate: PeopleTableViewControllerDelegate?
    
    var noOfPeople: Int?
    var people: [Person]?
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Update functions
    
    // MARK: - Functions
    
    func updateAllNames()
    {
        for cell in tableView.visibleCells
        {
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            var name = (cell as! PeopleTableViewCell).nameTF.text ?? ""
            if name == ""
            {
                // This is for when the user hasn't entered anything then the text will be "".
                // Therefore assigning default value.
                name = "Person \(indexPath.row + 1)"
            }
            
            if let people = self.people
            {
                if indexPath.row < people.count
                {
                    if let itemsHad = people[indexPath.row].itemsHad
                    {
                        self.people![indexPath.row] = Person(name: name, itemsHad: itemsHad)
                    }
                    else
                    {
                        self.people![indexPath.row] = Person(name: name, itemsHad: nil)
                    }
                }
                else
                {
                    self.people?.append(Person(name: name, itemsHad: nil))
                }
            }
            else
            {
                self.people = [Person(name: name, itemsHad: nil)]
            }
        }
    }
    
    // MARK: - Action functions
    
    @IBAction func updateButtonTapped(_ sender: UIBarButtonItem)
    {
        updateAllNames()
        
        let alertVC = UIAlertController(title: nil, message: "Default names will be inserted for fields that are empty.", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let updateAction = UIAlertAction(title: "Update", style: .default,  handler: { action in
            self.delegate?.peopleTableViewController(self, didUpdatePeopleNamesOf: self.people)
            self.tableView.reloadData()
        })
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(updateAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func filleDefaultNamesButtonTapped(_ sender: UIBarButtonItem)
    {
        for cell in tableView.visibleCells
        {
            if (cell as! PeopleTableViewCell).nameTF.hasText == false
            {
                (cell as! PeopleTableViewCell).nameTF.text = "Person \(tableView.indexPath(for: cell)!.row + 1)"
            }
        }
    }
    
    @IBAction func clearNamesButtonTapped(_ sender: UIBarButtonItem)
    {
        for cell in tableView.visibleCells
        {
            (cell as! PeopleTableViewCell).nameTF.text = ""
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let noOfPeople = noOfPeople
        {
            return noOfPeople
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personNameCell", for: indexPath) as! PeopleTableViewCell
        
        // indexPath.row < peopleNames.count --> This condition is for situations like for when the user adds another person (n people) but the list only has n-1 names so for that situation it will throw an error. This condition prevents that. If new person is added then the system will put a new cell with the placeholder.
        if let people = people, indexPath.row < people.count
        {
            cell.nameTF.text = people[indexPath.row].name
        }
        else
        {
            cell.nameTF.placeholder = "Person\(indexPath.row + 1) name"
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
