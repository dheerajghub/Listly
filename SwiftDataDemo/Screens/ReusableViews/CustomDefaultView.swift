//
//  CustomDefaultView.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 24/09/23.
//

import UIKit

class CustomDefaultView: UIView {

    // MARK: - PROPERTIES
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    let defaultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 50
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let defaultTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let defaultActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.tapFeedback()
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
        addSubview(stackView)
        //stackView.addArrangedSubview(defaultImageView)
        stackView.addArrangedSubview(defaultTitleLabel)
        stackView.addArrangedSubview(defaultActionButton)
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
//            defaultImageView.widthAnchor.constraint(equalToConstant: 100),
//            defaultImageView.heightAnchor.constraint(equalToConstant: 100),
            
            defaultActionButton.widthAnchor.constraint(equalToConstant: 250),
            defaultActionButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }

}
