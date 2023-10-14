//
//  CustomAlertViewController.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 24/09/23.
//

import UIKit

enum CustomAlertType {
    case actionSheet
    case `default`
}

class CustomAlertViewController: UIViewController {

    // MARK: PROPERTIES -
    var alertType: CustomAlertType?
    var message: String = ""
    var actionCallback: ((Bool) -> Void)?
    
    let backCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.4)
        return view
    }()
    
    // MARK: - Action sheet
    
    lazy var actionSheetView: CustomActionSheetView = {
        let view = CustomActionSheetView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        return view
    }()
    
    //:
    
    // MARK: - Alert Sheet
    
    lazy var alertSheetView: CustomAlertSheetView = {
        let view = CustomAlertSheetView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        return view
    }()
    
    //:
    
    // MARK: MAIN -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    init(alertType: CustomAlertType? = .default, message: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertType = alertType
        self.message = message
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.addSubview(backCoverView)
        view.addSubview(actionSheetView)
        view.addSubview(alertSheetView)
    }
    
    func setUpConstraints(){
        backCoverView.pin(to: view)
        alertSheetView.pin(to: view)
        NSLayoutConstraint.activate([
            actionSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            actionSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            actionSheetView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            actionSheetView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    func setupUI(){
        if alertType == .actionSheet {
            actionSheetView.isHidden = false
            alertSheetView.isHidden = true
            actionSheetView.headerView.headerTitle.text = message
        } else {
            actionSheetView.isHidden = true
            alertSheetView.isHidden = false
            alertSheetView.messageLabel.text = message
        }
        
    }
    
    // MARK: - ACTION
    
    @objc func actionButtonTapped(){
        self.dismiss(animated: true)
        actionCallback?(true)
    }
    
    @objc func cancelButtonTapped(){
        self.dismiss(animated: true)
    }

}
