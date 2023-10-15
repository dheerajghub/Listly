//
//  TaskPreviewViewController.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 01/10/23.
//

import UIKit

class TaskPreviewViewController: UIViewController {

    // MARK: PROPERTIES -
    
    var task: TaskModel? {
        didSet {
            manageCell()
        }
    }
    
    let customTaskView: TaskView = {
        let view = TaskView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: MAIN -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .clear
        view.addSubview(customTaskView)
    }
    
    func setUpConstraints(){
        customTaskView.pin(to: view)
    }
    
    func manageCell(){
        guard let task else { return }
        customTaskView.task = task
    }

}
