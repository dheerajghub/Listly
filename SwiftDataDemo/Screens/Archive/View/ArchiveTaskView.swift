//
//  ArchiveTaskView.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 14/10/23.
//

import UIKit

class ArchiveTaskView: UIView {

    // MARK: PROPERTIES -
    
    var forPreview: Bool = false {
        didSet {
            setUpConstraints()
            previewChange()
        }
    }
    
    var forEdit: Bool = false {
        didSet {
            updateSelectionUI()
            manageSelectionUpdates()
        }
    }
    
    var task: TaskModel? {
        didSet {
            manageCell()
        }
    }
    
    var taskLabelBottomConstraints: NSLayoutConstraint?
    var cardCoverLeadingConstraint: NSLayoutConstraint?
    
    let selectorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0
        imageView.clipsToBounds = true
        imageView.transform = .init(scaleX: 0.5, y: 0.5)
        return imageView
    }()
    
    let cardCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        view.layer.borderWidth = 1
        return view
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
        cardCoverView.addSubview(taskLabel)
        cardCoverView.addSubview(timeLabel)
        
        addSubview(selectorImageView)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            
            selectorImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            selectorImageView.widthAnchor.constraint(equalToConstant: 20),
            selectorImageView.heightAnchor.constraint(equalToConstant: 20),
            selectorImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            cardCoverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: forPreview ? 0 : -15),
            cardCoverView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: forPreview ? 0 : -5),
            cardCoverView.topAnchor.constraint(equalTo: topAnchor, constant: forPreview ? 0 : 5),
            
            taskLabel.leadingAnchor.constraint(equalTo: cardCoverView.leadingAnchor, constant: 15),
            taskLabel.trailingAnchor.constraint(equalTo: cardCoverView.trailingAnchor, constant: -15),
            taskLabel.topAnchor.constraint(equalTo: cardCoverView.topAnchor, constant: 10),
            
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            timeLabel.bottomAnchor.constraint(equalTo: cardCoverView.bottomAnchor, constant: -10),
            timeLabel.trailingAnchor.constraint(equalTo: cardCoverView.trailingAnchor, constant: -20)
            
        ])
        
        taskLabelBottomConstraints = taskLabel.bottomAnchor.constraint(equalTo: cardCoverView.bottomAnchor, constant: -10) // 35
        taskLabelBottomConstraints?.isActive = true
        
        cardCoverLeadingConstraint = cardCoverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: forPreview ? 0 : 15)
        cardCoverLeadingConstraint?.isActive = true
    }
    
    func manageCell(){
        
        guard let task else { return }
        taskLabel.text = task.taskName ?? ""
        
        manageSelectionUpdates()
    }
    
    func previewChange(){
        cardCoverView.layer.borderWidth = forPreview ? 0 : 1
    }
    
    func manageSelectionUpdates(){
        if forEdit {
            
            guard let task else { return }
            let isSelected = task.isSelectedForEditing
            
            let selectedImage = UIImage(named: "ic_checkbox_selected")?.withRenderingMode(.alwaysTemplate)
            
            let unselectedImage = UIImage(named: "ic_checkbox_unselected")?.withRenderingMode(.alwaysTemplate)
            
            let selectedColor = UIColor.black
            let unselectedColor = UIColor.lightGray.withAlphaComponent(0.5)
            
            cardCoverView.layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.lightGray.withAlphaComponent(0.2).cgColor
            cardCoverView.layer.borderWidth = isSelected ? 2 : 1
            
            selectorImageView.image = isSelected ? selectedImage : unselectedImage
            selectorImageView.tintColor = isSelected ? selectedColor : unselectedColor
            
            cardCoverView.backgroundColor = isSelected ? .lightGray.withAlphaComponent(0.2) : .clear
            
        }
    }
    
    func updateSelectionUI(){
        cardCoverLeadingConstraint?.constant = forEdit ? 45 : 15
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1){
            self.selectorImageView.transform = self.forEdit ? .identity : .init(scaleX: 0.6, y: 0.6)
            self.selectorImageView.alpha = self.forEdit ? 1 : 0
            self.layoutIfNeeded()
        }
        
    }

}
