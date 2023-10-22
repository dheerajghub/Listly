//
//  TaskView.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 02/10/23.
//

import UIKit

class TaskView: UIView {

    // MARK: PROPERTIES -
    
    var forPreview: Bool = false {
        didSet {
            setUpConstraints()
            previewChange()
        }
    }
    
    var task: TaskModel? {
        didSet {
            manageCell()
        }
    }
    
    var taskLabelBottomConstraints: NSLayoutConstraint?
    
    let cardCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let selectorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        addSubview(cardCoverView)
        cardCoverView.addSubview(selectorImageView)
        cardCoverView.addSubview(taskLabel)
        cardCoverView.addSubview(timeLabel)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            
            cardCoverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: forPreview ? 0 : 15),
            cardCoverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: forPreview ? 0 : -15),
            cardCoverView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: forPreview ? 0 : -5),
            cardCoverView.topAnchor.constraint(equalTo: topAnchor, constant: forPreview ? 0 : 5),
            
            selectorImageView.leadingAnchor.constraint(equalTo: cardCoverView.leadingAnchor, constant: 10),
            selectorImageView.topAnchor.constraint(equalTo: cardCoverView.topAnchor, constant: 10),
            selectorImageView.widthAnchor.constraint(equalToConstant: 20),
            selectorImageView.heightAnchor.constraint(equalToConstant: 20),
            
            taskLabel.leadingAnchor.constraint(equalTo: selectorImageView.trailingAnchor, constant: 10),
            taskLabel.trailingAnchor.constraint(equalTo: cardCoverView.trailingAnchor, constant: -15),
            taskLabel.topAnchor.constraint(equalTo: cardCoverView.topAnchor, constant: 10),
            
            timeLabel.leadingAnchor.constraint(equalTo: selectorImageView.trailingAnchor, constant: 10),
            timeLabel.bottomAnchor.constraint(equalTo: cardCoverView.bottomAnchor, constant: -10),
            timeLabel.trailingAnchor.constraint(equalTo: cardCoverView.trailingAnchor, constant: -20)
            
        ])
        
        taskLabelBottomConstraints = taskLabel.bottomAnchor.constraint(equalTo: cardCoverView.bottomAnchor, constant: -10) // -35
        taskLabelBottomConstraints?.isActive = true
    }
    
    func manageCell(){
        
        guard let task else { return }
        
        // 0 is for todo tasks
        let taskStatus = TaskStatus(rawValue: task.taskStatus)
        
        if let dueOn = task.dueOn {
            // formatted date string
            timeLabel.isHidden = false
            timeLabel.text = dueOn.dueOnFormat()
            taskLabelBottomConstraints?.constant = -32
        } else {
            timeLabel.isHidden = true
            taskLabelBottomConstraints?.constant = -10
        }
        
        // selection UI
        let taskSelected = (taskStatus == .todo) ? false : true
        manageSelection(isSelected: taskSelected)

    }
    
    func manageSelection(isSelected: Bool) {
        
        guard let task else { return }
        
        let taskTitle = task.taskName ?? ""
        
        let unselectedImage = UIImage(named: "ic_uncheck")?.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(named: "ic_check")?.withRenderingMode(.alwaysTemplate)
        
        let selectedColor = UIColor.black
        let unselectedColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(taskTitle)")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: isSelected ? 1 : 0, range: NSRange(location: 0, length: attributeString.length))
        
        selectorImageView.image = isSelected ? selectedImage : unselectedImage
        selectorImageView.tintColor = isSelected ? selectedColor : unselectedColor
        taskLabel.textColor = isSelected ? .darkGray.withAlphaComponent(0.7) : .black
        taskLabel.attributedText = attributeString
        
    }
    
    func previewChange(){
        cardCoverView.layer.borderWidth = forPreview ? 0 : 1
    }

}
