//
//  FormSimpleTextView.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import UIKit

class FormSimpleTextView: UIView {

    // MARK: - PROPERTIES
    
    let formLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(formLabel)
        addSubview(actionButton)
    }
    
    func setupConstraints(){
        actionButton.pin(to: self)
        NSLayoutConstraint.activate([
            formLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            formLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            formLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            formLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
        ])
    }

}
