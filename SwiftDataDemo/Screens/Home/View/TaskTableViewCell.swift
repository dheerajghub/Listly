//
//  TaskTableViewCell.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 23/09/23.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        contentView.backgroundColor = .white
        backgroundColor = .clear
        addSubview(customTaskView)
    }
    
    func setUpConstraints(){
        customTaskView.pin(to: self)
    }
    
    func manageCell(){
        guard let task else { return }
        customTaskView.task = task
    }

}
