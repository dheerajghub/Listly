//
//  TaskViewController+Delegate.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 21/10/23.
//

import UIKit

extension TasksViewController: TaskActionDelegate {
    
    func didActionButtonTapped() {
        
        guard let homeViewModel else {
            // show alert if needed
            return
        }
        
        let text = taskTextView.text ?? ""
        
        if text == "" || text == "e.g. My awesome task" || taskTextView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            // show alert if needed
            return
        }
        
        // update task
        if homeViewModel.isEditing {
            guard let index = homeViewModel.editableTaskIndex else { return }
            let currentTask = homeViewModel.tasks[index]
            currentTask.taskName = text
            currentTask.dueOn = dueOn
            homeViewModel.updateTask(task: currentTask)
        } else {
            
            // get total count of tasks
            let totalTask = homeViewModel.tasks.count
            
            // last task orderNum + 1
            var lastTaskOrderNum = 0
            if totalTask > 1 {
                lastTaskOrderNum =  homeViewModel.tasks[totalTask - 1].orderNum ?? 0
            }
            
            let taskData = TaskModel(taskName: text, orderNum: lastTaskOrderNum + 1, dueOn: dueOn)
            homeViewModel.saveTask(modelData: taskData)
        }
        
        
        self.dismiss(animated: true)
        self.updateCallback?()
        
    }
    
    func didDueActionButtonTapped() {
        
        view.endEditing(true)
        
        let dateTimeController = DateTimePickerViewController()
        dateTimeController.modalPresentationStyle = .pageSheet
        
        if let sheet = dateTimeController.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                540 + windowConstant.getBottomPadding
            })]
        }
        
        dateTimeController.selectedDate = dueOn
        
        dateTimeController.updateCallback = { [weak self] date in
            guard let self else { return }
            self.dueOn = date
            self.updateBottomUI(date)
            self.taskTextView.becomeFirstResponder()
        }
        
        self.present(dateTimeController, animated: true)
        
    }
    
}

extension TasksViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: taskTextView.frame.width , height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let actionButton = bottomActionView.actionButton
        
        
        if estimatedSize.height < 50.0 {
            self.taskTextViewHeightConstraint?.constant = 50
        } else {
            self.taskTextViewHeightConstraint?.constant = estimatedSize.height
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        
        if textView.text == "" || textView.text == "e.g. My awesome task" || taskTextView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            // show alert if needed
            actionButton.isEnabled = false
            actionButton.alpha = 0.3
        } else {
            actionButton.isEnabled = true
            actionButton.alpha = 1
        }
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        
        // dismiss the keyboard if newline character typed
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        
        if updatedText.isEmpty {
            textView.text = "e.g. My awesome task"
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
}
