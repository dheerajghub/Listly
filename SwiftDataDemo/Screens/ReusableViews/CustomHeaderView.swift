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
    
    let actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.axis = .horizontal
        return stackView
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        
        addSubview(actionStackView)
        actionStackView.addArrangedSubview(actionButton)
        
        addSubview(dividerView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            headerTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            actionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            actionStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionStackView.heightAnchor.constraint(equalToConstant: 45),
            
            actionButton.heightAnchor.constraint(equalToConstant: 35),
            actionButton.widthAnchor.constraint(equalToConstant: 35),
            
            dividerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1.5)
        ])
    }

}

