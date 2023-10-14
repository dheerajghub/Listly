//
//  CustomAlertSheetView.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 01/10/23.
//

import UIKit

class CustomAlertSheetView: UIView {

    // MARK: PROPERTIES -
    
    let cardCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Message"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let actionStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.spacing = 0
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        return stackview
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Yes", for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.tapFeedback()
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = [.layerMaxXMaxYCorner]
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.tapFeedback()
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = [.layerMinXMaxYCorner]
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
        addSubview(cardCoverView)
        cardCoverView.addSubview(messageLabel)
        cardCoverView.addSubview(actionStackView)
        
        actionStackView.addArrangedSubview(cancelButton)
        actionStackView.addArrangedSubview(actionButton)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            
            cardCoverView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardCoverView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: 15),
            cardCoverView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            cardCoverView.bottomAnchor.constraint(equalTo: actionStackView.bottomAnchor),
            cardCoverView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            actionStackView.leadingAnchor.constraint(equalTo: cardCoverView.leadingAnchor),
            actionStackView.trailingAnchor.constraint(equalTo: cardCoverView.trailingAnchor),
            actionStackView.heightAnchor.constraint(equalToConstant: 50),
            
            messageLabel.leadingAnchor.constraint(equalTo: cardCoverView.leadingAnchor, constant: 15),
            messageLabel.topAnchor.constraint(equalTo: cardCoverView.topAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(equalTo: cardCoverView.trailingAnchor, constant: -15),
            messageLabel.bottomAnchor.constraint(equalTo: actionStackView.topAnchor, constant: -15)
            
        ])
    }

}
