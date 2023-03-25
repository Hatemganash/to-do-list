//
//  AddItemViewController.swift
//  to-do-list
//
//  Created by Hatem on 22/03/2023.
//

import UIKit

protocol AddItemViewControllerDelegate: AnyObject {
  func addItemViewControllerDidCancel (
    _ controller: AddItemViewController )
  func addItemViewController (
    _ controller: AddItemViewController,didFinishAdding
    item: ChecklistItem
  )
}


class AddItemViewController: UITableViewController,UITextFieldDelegate {
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }
    @IBAction func done() {
        let item = ChecklistItem()
        item.text = textfield.text!
        delegate?.addItemViewController(self, didFinishAdding: item)
    }
    
    weak var delegate: AddItemViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
