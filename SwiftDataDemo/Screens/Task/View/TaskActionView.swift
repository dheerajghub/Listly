//
//  TaskActionView.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 21/10/23.
//

import UIKit

protocol TaskActionDelegate {
    func didActionButtonTapped()
    func didDueActionButtonTapped()
}

class TaskActionView: UIView {

    // MARK: PROPERTIES -
    
    var delegate: TaskActionDelegate?
    
    lazy var dueActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_calendar")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .black
        button.setTitle(" Due", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.layer.cornerRadius = 17.5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.addTarget(self, action: #selector(dueActionButtonTapped), for: .touchUpInside)
        button.tapFeedback()
        return button
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = 17.5
        button.setImage(UIImage(named: "ic_arrow_up")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.layer.cornerCurve = .continuous
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        button.tapFeedback()
        button.isEnabled = false
        button.alpha = 0.3
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
        addSubview(dueActionButton)
        addSubview(actionButton)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            
            dueActionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            dueActionButton.heightAnchor.constraint(equalToConstant: 35),
            dueActionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 35),
            actionButton.widthAnchor.constraint(equalToConstant: 35)
            
        ])
    }
    
    // MARK: - ACTION
    
    @objc func actionButtonTapped(){
        delegate?.didActionButtonTapped()
    }
    
    @objc func dueActionButtonTapped(){
        delegate?.didDueActionButtonTapped()
    }

}
