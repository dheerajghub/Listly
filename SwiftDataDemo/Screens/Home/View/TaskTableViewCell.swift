//
//  TaskTableViewCell.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 23/09/23.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    // MARK: PROPERTIES -
    
    
    
    override var isSelected: Bool {
        didSet {
            
            let unselectedImage = UIImage(named: "ic_uncheck")?.withRenderingMode(.alwaysTemplate).withTintColor(.lightGray.withAlphaComponent(0.2))
            let selectedImage = UIImage(named: "ic_check")?.withRenderingMode(.alwaysTemplate).withTintColor(.black)
            
            selectorImageView.image = isSelected ? selectedImage : unselectedImage
            
        }
    }
    
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
        return label
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
        addSubview(cardCoverView)
        cardCoverView.addSubview(selectorImageView)
        cardCoverView.addSubview(taskLabel)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            
            cardCoverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cardCoverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            cardCoverView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            cardCoverView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            selectorImageView.leadingAnchor.constraint(equalTo: cardCoverView.leadingAnchor, constant: 10),
            selectorImageView.topAnchor.constraint(equalTo: cardCoverView.topAnchor, constant: 10),
            selectorImageView.widthAnchor.constraint(equalToConstant: 30),
            selectorImageView.heightAnchor.constraint(equalToConstant: 30),
            
            taskLabel.leadingAnchor.constraint(equalTo: selectorImageView.trailingAnchor, constant: 10),
            taskLabel.trailingAnchor.constraint(equalTo: cardCoverView.trailingAnchor, constant: 15),
            taskLabel.bottomAnchor.constraint(equalTo: cardCoverView.bottomAnchor, constant: -10),
            taskLabel.topAnchor.constraint(equalTo: cardCoverView.topAnchor, constant: 10)
            
        ])
    }

}
