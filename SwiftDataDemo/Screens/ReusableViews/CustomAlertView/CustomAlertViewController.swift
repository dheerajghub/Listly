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
    
    let backCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.4)
        return view
    }()
    
    // MARK: - Action sheet
    
    
    
    //:
    
    // MARK: MAIN -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    init(alertType: CustomAlertType? = .default) {
        super.init(nibName: nil, bundle: nil)
        self.alertType = alertType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.addSubview(backCoverView)
    }
    
    func setUpConstraints(){
        backCoverView.pin(to: view)
    }

}
