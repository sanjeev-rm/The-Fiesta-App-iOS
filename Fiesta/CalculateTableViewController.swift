//
//  CalculateTableViewController.swift
//  Fiesta
//
//  Created by Sanjeev RM on 31/12/22.
//

import UIKit

class CalculateTableViewController: UITableViewController
{
    var people: [Person]?
    var tax: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    /// This function calculates the amount to be paid by a person.
    /// - parameters: person -> The person of type Person.
    /// - parameters: tax -> the tax percentage.
    func calculateAmountToBePaidByPerson(person : Person, tax : Double) -> Double
    {
        guard let itemsList = person.itemsHad else { return 0 }
        
        var sum : Double = 0
        for item in itemsList
        {
            sum = sum + (item.price * item.count!)
        }
        
        let finalAmount = ((100.0 + tax) * (sum)) / 100.0
        return finalAmount
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let people = people else { return 0 }
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "amountCell", for: indexPath)
     
     guard let person = people?[indexPath.row], let tax = tax else { return cell }

     var content = cell.defaultContentConfiguration()
     content.text = person.name
     content.secondaryText = calculateAmountToBePaidByPerson(person: person, tax: tax).formatted(.currency(code: "usd"))
     cell.contentConfiguration = content

     return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
