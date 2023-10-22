//
//  ArchiveTaskViewController+Delegate.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 14/10/23.
//

import UIKit

extension ArchivedTaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let taskViewModel else { return Int() }
        return taskViewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let taskViewModel else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArchivedTaskTableViewCell", for: indexPath) as! ArchivedTaskTableViewCell
        cell.selectionStyle = .none
        
        if taskViewModel.tasks.count > 0, let task = taskViewModel.tasks[safe: indexPath.row] {
            cell.task = task
            cell.forEdit = archiveViewModel.isEditing
            cell.isSelected = task.isSelectedForEditing
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ArchivedTaskTableViewCell {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                cell.archiveView.cardCoverView.transform = .init(scaleX: 0.98, y: 0.98)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ArchivedTaskTableViewCell {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                cell.archiveView.cardCoverView.transform = .identity
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let taskViewModel else { return }
        
        /// if in editing mode
        if archiveViewModel.isEditing {
        
            if taskViewModel.tasks.count > 0 {
                let task = taskViewModel.tasks[indexPath.row]
                task.isSelectedForEditing.toggle()
                taskViewModel.updateTask(task: task, isSelectedForEditing: task.isSelectedForEditing)
                self.archivedTaskTableView.reloadRows(at: [indexPath], with: .none)
                
                if task.isSelectedForEditing {
                    archiveViewModel.selectedItems += 1
                } else {
                    archiveViewModel.selectedItems -= 1
                }
                
            }
            
            if archiveViewModel.selectedItems > 0 {
                makeBottomActions(active: true)
            } else {
                makeBottomActions(active: false)
            }
            
        }
        
    }
    
}
