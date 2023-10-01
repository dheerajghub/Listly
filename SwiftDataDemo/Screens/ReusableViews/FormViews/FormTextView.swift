//
//  FormTextView.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import UIKit

class FormTextView: UIView {
    
    // MARK: - PROPERTIES
    
    var textLabelLeadingAnchor: NSLayoutConstraint?
    
    let formTextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    let outerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 5
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter Something..",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.7),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)
            ]
        )
        textField.tintColor = .black
        textField.font = .systemFont(ofSize: 14, weight: .regular)
        textField.isHidden = true
        textField.textColor = .black
        return textField
    }()
    
    let customTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dummy form text label"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray.withAlphaComponent(0.7)
        return label
    }()
    
    let copyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.imageView?.tintColor = .white
        button.isHidden = true
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
        addSubview(outerView)
        outerView.addSubview(customTextLabel)
        outerView.addSubview(inputTextField)
        outerView.addSubview(copyButton)
        outerView.addSubview(formTextImageView)
    }
    
    func setupConstraints(){
        outerView.pin(to: self)
        NSLayoutConstraint.activate([
            
            customTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            customTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            inputTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            inputTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            copyButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            copyButton.heightAnchor.constraint(equalToConstant: 45),
            copyButton.widthAnchor.constraint(equalToConstant: 45),
            copyButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            formTextImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            formTextImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            formTextImageView.widthAnchor.constraint(equalToConstant: 35),
            formTextImageView.heightAnchor.constraint(equalToConstant: 35)
            
        ])
        
        textLabelLeadingAnchor = customTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
        textLabelLeadingAnchor?.isActive = true
        
    }

}
