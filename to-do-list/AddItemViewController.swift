//
//  AddItemViewController.swift
//  to-do-list
//
//  Created by Hatem on 22/03/2023.
//

import UIKit

protocol AddItemViewControllerDelegate: AnyObject {
  func itemDetailViewControllerDidCancel (
    _ controller: AddItemViewController )
  func itemDetailViewController (
    _ controller: AddItemViewController,didFinishAdding
    item: ChecklistItem
  )
    func itemDetailViewController(
      _ controller: AddItemViewController,
      didFinishEditing item: ChecklistItem
    )
}


class AddItemViewController: UITableViewController,UITextFieldDelegate {
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var itemToEdit: ChecklistItem?
    weak var delegate: AddItemViewControllerDelegate?
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textfield.text!
            delegate?.itemDetailViewController(
        self,
              didFinishEditing: item)
          } else {
            let item = ChecklistItem()
            item.text = textfield.text!
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textfield.text = item.text
            doneBarButton.isEnabled = true
        
        }
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    override func viewWillAppear(_ animated: Bool) {
        textfield.becomeFirstResponder()
    
}
    func textField(
      _ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String
    ) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
        
    }
    }
