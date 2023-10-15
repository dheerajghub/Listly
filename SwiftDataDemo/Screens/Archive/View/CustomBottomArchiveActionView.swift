//
//  CustomBottomArchiveActionView.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 15/10/23.
//

import UIKit

class CustomBottomArchiveActionView: UIView {

    // MARK: PROPERTIES -
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.4)
        return view
    }()
    
    let actionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var unarchiveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_unarchive")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.setTitle("  Unarchive", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        button.tapFeedback()
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.setTitle("  Cancel", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.appRed
        button.layer.cornerRadius = 25
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
        backgroundColor = .white
        addSubview(dividerView)
        addSubview(actionView)
        actionView.addSubview(actionStackView)
        
        actionStackView.addArrangedSubview(unarchiveButton)
        actionStackView.addArrangedSubview(cancelButton)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.topAnchor.constraint(equalTo: topAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            actionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionView.topAnchor.constraint(equalTo: topAnchor),
            actionView.heightAnchor.constraint(equalToConstant: 70),
            
            actionStackView.leadingAnchor.constraint(equalTo: actionView.leadingAnchor, constant: 15),
            actionStackView.trailingAnchor.constraint(equalTo: actionView.trailingAnchor, constant: -15),
            actionStackView.centerYAnchor.constraint(equalTo: actionView.centerYAnchor),
            actionStackView.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }

}
