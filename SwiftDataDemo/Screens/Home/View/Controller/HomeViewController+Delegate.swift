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
                } else {
                    homeViewModel.updateTask(task: task, taskStatus: 1)
                }
                self.taskTableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                cell.customTaskView.cardCoverView.transform = .init(scaleX: 0.98, y: 0.98)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                cell.customTaskView.cardCoverView.transform = .identity
            }
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let task = homeViewModel.tasks[indexPath.row]
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell else { return nil }
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                
                let controller = TaskPreviewViewController()
                controller.task = task
                controller.customTaskView.forPreview = true
                controller.preferredContentSize = CGSize(width: cell.customTaskView.frame.width, height: cell.customTaskView.frame.height)
                return controller
                
            },
            actionProvider: { _ in
                
                let editTask = UIAction(
                    title: "Edit",
                    image: UIImage(named: "ic_edit_menu"),
                    identifier: nil
                ) { _ in
                    
                    self.homeViewModel.isEditing = true
                    self.homeViewModel.editableTaskIndex = indexPath.row
                    
                    let taskController = TasksViewController(homeViewModel: self.homeViewModel)
                    taskController.modalPresentationStyle = .overCurrentContext
                    taskController.modalTransitionStyle = .crossDissolve
                    
                    taskController.updateCallback = { [weak self] in
                        guard let self else { return }
                        self.fetchData()
                    }
                    
                    self.present(taskController, animated: true)
                }
                
                let removeTask = UIAction(
                    title: "Delete",
                    image: UIImage(named: "ic_trash_menu"),
                    identifier: nil,
                    attributes: .destructive
                ) { _ in
                    
                    // Show alert before deleting
                    Helper.showAlert(message: "Are you sure want to delete this task?" , controller: self, alertType: .default) { [weak self] response in
                        guard let self else { return }
                        if response {
                            // delete the task
                            self.homeViewModel.deleteTask(task: task)
                            self.fetchData()
                        }
                    }
                    
                }
                
                
                let archiveTask = UIAction(
                    title: "Archive",
                    image: UIImage(named: "ic_archiv_menu")
                ) { _ in
                    // archive the task
                    self.homeViewModel.updateTask(task: task, isArchived: true)
                    
                    // animate archive button
                    
                    UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 1) {
                        
                        self.headerView.trailingActionButton.transform = .init(scaleX: 1.1, y: 1.1)
                        self.headerView.trailingActionButton.backgroundColor = UIColor.colorWithHex(color: "#FFB100")
                        self.headerView.trailingActionButton.imageView?.tintColor = .white
                        
                    } completion: { finished in
                        UIView.animate(withDuration: 0.3) {
                            self.headerView.trailingActionButton.transform = .identity
                            self.headerView.trailingActionButton.backgroundColor = .clear
                            self.headerView.trailingActionButton.imageView?.tintColor = .black
                        }
                    }
                    
                    //:
                    
                    self.homeViewModel.tasks.removeAll()
                    self.taskTableView.reloadData()
                    self.fetchData()
                }
                
                return UIMenu(
                    title: "Task Actions",
                    /// if task  completed, we cannot archive that task
                    children: task.taskStatus == 0 ? [editTask, archiveTask, removeTask] : [editTask, removeTask]
                )
            })
    }
    
}
