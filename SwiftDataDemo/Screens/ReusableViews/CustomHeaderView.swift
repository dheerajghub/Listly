//
//  CustomHeaderView.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import UIKit

class CustomHeaderView: UIView {

    // MARK: - PROPERTIES
    
    let headerTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // Leading action button
    
    let leadingActionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.axis = .horizontal
        return stackView
    }()
    
    let leadingActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tapFeedback()
        button.isHidden = true
        return button
    }()
    
    //:
    
    // Trailing action button
    
    let trailingActionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.axis = .horizontal
        return stackView
    }()
    
    let trailingActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tapFeedback()
        button.isHidden = true
        return button
    }()
    
    //:
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
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
        addSubview(headerTitle)
        
        addSubview(trailingActionStackView)
        trailingActionStackView.addArrangedSubview(trailingActionButton)
        
        addSubview(leadingActionStackView)
        leadingActionStackView.addArrangedSubview(leadingActionButton)
        
        addSubview(dividerView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            headerTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            leadingActionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            leadingActionStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leadingActionStackView.heightAnchor.constraint(equalToConstant: 40),
            
            leadingActionButton.heightAnchor.constraint(equalToConstant: 40),
            leadingActionButton.widthAnchor.constraint(equalToConstant: 40),
            
            trailingActionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            trailingActionStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingActionStackView.heightAnchor.constraint(equalToConstant: 40),
            
            trailingActionButton.heightAnchor.constraint(equalToConstant: 40),
            trailingActionButton.widthAnchor.constraint(equalToConstant: 40),
            
            
            dividerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1.5)
        ])
    }

}

