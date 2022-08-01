//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Joseph Gilmore on 5/27/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import DynamicColor

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        
    }
    
    //MARK: - Tableview Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let selectedCategory = categories?[indexPath.row]
        cell.textLabel?.text = selectedCategory?.name ?? "No Categories Added Yet"
        let color = UIColor(hexString: selectedCategory?.cellColor ?? "#DA968A")
        cell.backgroundColor = color
       
        return cell
    }
    
    func testColor() -> String {
        let colors = ["#9e3fba","#9245c0","#854bc5","#7751ca","#6755ce","#545ad1","#3d5ed4","#1261d5","#0065d6","#0067d6","#006ad6","#006cd5","#006ed3","#0070d0","#0071cd","#0072c9","#0073c4","#0074bf","#0074ba","#0075b4","#0075ae","#0075a7","#0075a0","#007599","#007492","#00748a","#007483","#00737b","#007274","#00726d","#007165","#00705e","#006f57","#006f50","#006e4a","#006d43","#006c3d","#006a38","#006932","#13682d"]
        let finalColor = colors.randomElement()
        
        return finalColor ?? "#DA968A"
    }
    
    //MARK: - Tableview Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation
    
    func save(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("error saving to context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory() {
        
        categories = realm.objects(Category.self)
        

        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write({
                    self.realm.delete(categoryForDeletion)
                })
            } catch {
                print("error deleting category \(error)")
            }
        }
    }
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let newCategory = UIAlertController(title: "New Category", message: nil, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if textField.text != "" {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.cellColor = self.testColor()
                self.save(category: newCategory)
            } else {
                return
            }
        }
        
        newCategory.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        newCategory.addAction(action)
        newCategory.addAction(cancel)
        present(newCategory, animated: true, completion: nil)
        
    }
}
