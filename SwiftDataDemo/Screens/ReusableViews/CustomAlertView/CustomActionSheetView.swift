//
//  CustomActionSheetView.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 24/09/23.
//

import UIKit

class CustomActionSheetView: UIView {

    // MARK: PROPERTIES -
    
    let actionOptionContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    let headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.headerTitle.text = "Message"
        view.headerTitle.font = .systemFont(ofSize: 12, weight: .medium)
        view.headerTitle.textColor = .lightGray
        return view
    }()
    
    // STACK OPTIONS
    
    let stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.spacing = 0
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        return stackview
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Yes", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.tapFeedback()
        return button
    }()
    
    //:
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("cancel", for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.tapFeedback()
        return button
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
        
        addSubview(actionOptionContentView)
        actionOptionContentView.addSubview(headerView)
        actionOptionContentView.addSubview(stackView)
        
        stackView.addArrangedSubview(actionButton)
        
        addSubview(cancelButton)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cancelButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            
            actionOptionContentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            actionOptionContentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            actionOptionContentView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            
            headerView.leadingAnchor.constraint(equalTo: actionOptionContentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: actionOptionContentView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: actionOptionContentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.leadingAnchor.constraint(equalTo: actionOptionContentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: actionOptionContentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: actionOptionContentView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}
