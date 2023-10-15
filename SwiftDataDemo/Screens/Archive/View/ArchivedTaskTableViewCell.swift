//
//  ArchivedTaskTableViewCell.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 14/10/23.
//

import UIKit

class ArchivedTaskTableViewCell: UITableViewCell {

    // MARK: PROPERTIES -
    
    var task: TaskModel? {
        didSet {
            archiveView.task = task
        }
    }
    
    var forEdit: Bool = false {
        didSet {
            archiveView.forEdit = forEdit
        }
    }
    
    let archiveView: ArchiveTaskView = {
        let view = ArchiveTaskView()
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
        backgroundColor = .clear
        addSubview(archiveView)
    }
    
    func setUpConstraints(){
        archiveView.pin(to: self)
    }

}
