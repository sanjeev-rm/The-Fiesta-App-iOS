//
//  PeopleTableViewController.swift
//  Fiesta
//
//  Created by Sanjeev RM on 25/12/22.
//

import UIKit

protocol PeopleTableViewControllerDelegate
{
    /// This function contains the updtes people array.
    func peopleTableViewController(_ controller: PeopleTableViewController, didUpdatePeopleNamesOf people: [Person]?)
}

class PeopleTableViewController: UITableViewController
{
    var delegate: PeopleTableViewControllerDelegate?
    
    var noOfPeople: Int?
    var people: [Person]?
    
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    @IBOutlet weak var fillDefaultNamesButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateButtonsState()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Update functions
    
    /// This function updates the state of the update button.
    /// This function also updates the state of the fill default names button.
    func updateButtonsState()
    {
        // Initially taking true, yes assuming atleast one TF is empty.
        var isAnyTFEmpty: Bool = true
        for cell in tableView.visibleCells
        {
            if (cell as! PeopleTableViewCell).nameTF.hasText == false
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
        fillDefaultNamesButton.isEnabled = isAnyTFEmpty
    }
    
    /// This function updates the names of all the people.
    func updateAllNames()
    {
        for cell in tableView.visibleCells
        {
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            let name = (cell as! PeopleTableViewCell).nameTF.text ?? ""
            
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
                    // This means new person has been added so appending.
                    self.people?.append(Person(name: name, itemsHad: nil))
                }
            }
            else
            {
                // This means the people array is nil i.e. no person has been creatd yet so we create the first person and initialize it.
                self.people = [Person(name: name, itemsHad: nil)]
            }
        }
    }
    
    // MARK: - Action functions
    
    /// This function is fired when the update button is tapped.
    @IBAction func updateButtonTapped(_ sender: UIBarButtonItem)
    {
        updateAllNames()
        
        let alertVC = UIAlertController(title: "Confirm Update", message: "Confirm people update.", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let updateAction = UIAlertAction(title: "Update", style: .default,  handler: { action in
            self.delegate?.peopleTableViewController(self, didUpdatePeopleNamesOf: self.people)
            self.updateButton.isEnabled = false
        })
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(updateAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    /// This function fills the default values to the text fields that are empty of the vc.
    /// This functin is fired when the "Fill Default names" button is tapped.
    @IBAction func fillDefaultNamesButton(_ sender: UIBarButtonItem)
    {
        for cell in tableView.visibleCells
        {
            if (cell as! PeopleTableViewCell).nameTF.hasText == false
            {
                (cell as! PeopleTableViewCell).nameTF.text = "Person \(tableView.indexPath(for: cell)!.row + 1)"
            }
        }
        
        updateButtonsState()
    }
    
    /// This function is fired everytime the value of the text fields are changed.
    @IBAction func textFieldsValueChanged(_ sender: UITextField)
    {
        updateButtonsState()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
