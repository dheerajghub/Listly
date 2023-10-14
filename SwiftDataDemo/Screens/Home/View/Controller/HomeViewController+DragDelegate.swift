//
//  HomeViewController+DragDelegate.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 02/10/23.
//

import UIKit

extension HomeViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        guard homeViewModel.tasks.count > 0 else { return [] }
        guard let cell = taskTableView.cellForRow(at: indexPath) as? TaskTableViewCell else { return [] }
        
        let task = homeViewModel.tasks[indexPath.row]
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = task
        dragItem.previewProvider = { () -> UIDragPreview? in
            let preview = UIView()
            preview.frame = CGRect(x: 0, y: 0, width: cell.customTaskView.frame.width * 0.7, height: cell.customTaskView.frame.height * 0.7)
            preview.layer.cornerRadius = 8
            
            let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.customTaskView.frame.width * 0.7, height: cell.customTaskView.frame.height * 0.7))
            imageview.translatesAutoresizingMaskIntoConstraints = false
            imageview.image = self.getCellSnapShot(for: indexPath)
            imageview.backgroundColor = .white
            preview.addSubview(imageview)
            
            return UIDragPreview(view: preview)
        }
        
        return [ dragItem ]
        
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var tasks = homeViewModel.tasks
        tasks[sourceIndexPath.row].orderNum = destinationIndexPath.row + 1
        tasks[destinationIndexPath.row].orderNum = sourceIndexPath.row + 1
        
        let mover = tasks.remove(at: sourceIndexPath.row)
        tasks.insert(mover, at: destinationIndexPath.row)
        
        // update model after change in the order
        homeViewModel.tasks = tasks
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell else { return false }
        return true
    }
    
    func getCellSnapShot(for indexPath: IndexPath) -> UIImage? {
        guard let cell = taskTableView.cellForRow(at: indexPath) as? TaskTableViewCell else { return nil }
        
        let tasks = homeViewModel.tasks
        
        // create new instance of a view for a snapshot
        let taskView = TaskView(frame: cell.bounds)
        taskView.task = tasks[indexPath.row]
        taskView.forPreview = true
        
        let snapshot = taskView.takeSnapshot()
        return snapshot
    }
    
}
