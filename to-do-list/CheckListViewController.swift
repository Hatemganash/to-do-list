
//  ViewController.swift
//  to-do-list
//
//  Created by Hatem on 19/03/2023.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    
    var items = [ChecklistItem]()
    var checklist: Checklist!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = checklist.name
        loadChecklistItems()
        
        let item1 = ChecklistItem()
          item1.text = "Welcome To your TO DO List "
          items.append(item1)

//        print("Documents folder is \(documentsDirectory())")
//        print("Data file path is \(dataFilePath())")
        
        }
    
    override func tableView(
      _ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
          return items.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
           withIdentifier: "ChecklistItem",
           for: indexPath)
        let item = items[indexPath.row]
        configureCheckmark(for: cell, with: item)
        configureText(for: cell, with: item)
          return cell
        }

               
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
            
        }
          tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
        
    }
    
    func configureCheckmark(for cell: UITableViewCell,with item: ChecklistItem)
    {
    let label = cell.viewWithTag(1001) as! UILabel
      if item.checked {
        label.text = "✓"
    } else {
        label.text = ""
      }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem)
    {
    let label = cell.viewWithTag(1000) as! UILabel
      label.text = item.text
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath)
    {
        items.remove(at: indexPath.row)
        let indexpath = [indexPath]
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveChecklistItems()
    }
    func itemDetailViewControllerDidCancel(
      _ controller: itemDetailViewController
    ){
      navigationController?.popViewController(animated: true)
    }
    func itemDetailViewController(
      _ controller: itemDetailViewController,
      didFinishAdding item: ChecklistItem
    )
    {
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated:true)
        saveChecklistItems()
    }
    func itemDetailViewController(
      _ controller: itemDetailViewController,
      didFinishEditing item: ChecklistItem
    ){
        if let index = items.firstIndex(of : item) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
    }
      navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    override func prepare(
      for segue: UIStoryboardSegue,
      sender: Any?
    ){
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! itemDetailViewController
            controller.delegate = self
            
        }
        else if segue.identifier == "EditItem" {
            let controller = segue.destination as! itemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
            
        }
        
    }
    func documentsDirectory() -> URL {
      let paths = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask)
      return paths[0]
    }
    func dataFilePath() -> URL {
      return
    documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        do {
        let data = try encoder.encode(items)
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
    } catch {
        print("Error encoding item array: \(error.localizedDescription)")
    }
        
    }
    func loadChecklistItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode(
                    [ChecklistItem].self,
                    from: data)
                
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
                
            }
            
        }
    }
}

