//
//  HomeViewController+Delegate.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 23/09/23.
//

import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        if homeViewModel.tasks.count > 0 {
            cell.task = homeViewModel.tasks[indexPath.row]
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) is TaskTableViewCell {
            if homeViewModel.tasks.count > 0 {
                let task = homeViewModel.tasks[indexPath.row]
                if task.taskStatus == 1 {
                    homeViewModel.updateTask(task: task, taskStatus: 0)
                    self.taskTableView.reloadRows(at: [indexPath], with: .fade)
                } else {
                    homeViewModel.updateTask(task: task, taskStatus: 1)
                    self.taskTableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard homeViewModel.tasks.count > 0 else { return nil }

        let task = homeViewModel.tasks[indexPath.row]
        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            // Show alert before deleting
            Helper.showAlert(message: "Are you sure want to delete this task?" , controller: self) { [weak self] response in
                guard let self else { return }
                if response {
                    // delete the task
                    self.homeViewModel.deleteTask(task: task)
                    self.fetchData()
                }
            }
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem])

        return swipeActions
    
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                cell.cardCoverView.transform = .init(scaleX: 0.98, y: 0.98)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                cell.cardCoverView.transform = .identity
            }
        }
    }
    
}
