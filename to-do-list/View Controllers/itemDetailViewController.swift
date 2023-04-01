//
//  AddItemViewController.swift
//  to-do-list
//
//  Created by Hatem on 22/03/2023.
//

import UIKit
import UserNotifications

protocol AddItemViewControllerDelegate: AnyObject {
  func itemDetailViewControllerDidCancel (
    _ controller: itemDetailViewController )
  func itemDetailViewController (
    _ controller: itemDetailViewController,didFinishAdding
    item: ChecklistItem
  )
    func itemDetailViewController(
      _ controller: itemDetailViewController,
      didFinishEditing item: ChecklistItem
    )
}


class itemDetailViewController: UITableViewController,UITextFieldDelegate {
   
    
    var itemToEdit: ChecklistItem?
    weak var delegate: AddItemViewControllerDelegate?
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func shouldRemindToggled(_ sender: Any) {
        textfield.resignFirstResponder()
        if shouldRemindSwitch.isOn{
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {_, _
           in
           }
        }
    }
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textfield.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.itemDetailViewController(self,didFinishEditing: item)
          } else {
            let item = ChecklistItem()
            item.text = textfield.text!
              item.shouldRemind=shouldRemindSwitch.isOn
              item.dueDate = datePicker.date
              item.scheduleNotification()
            delegate?.itemDetailViewController(self,didFinishAdding: item)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textfield.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            datePicker.date = item.dueDate
            
        }
        

        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    
    {
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
