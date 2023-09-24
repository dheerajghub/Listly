//
//  TasksViewController.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import UIKit

class TasksViewController: UIViewController {

    // MARK: PROPERTIES -
    
    var homeViewModel: HomeViewModel?
    var updateCallback: (() -> Void)?
    
    let headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionStackView.isHidden = true
        view.headerTitle.text = "Add Task"
        view.headerTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        return view
    }()
    
    let taskInputView: FormTextWithTitleView = {
        let inputView = FormTextWithTitleView()
        inputView.translatesAutoresizingMaskIntoConstraints = false
        
        inputView.formTitleLabel.text = "Task Name"
        inputView.formTextView.customTextLabel.isHidden = true
        inputView.formTextView.copyButton.isHidden = true
        inputView.formTextView.inputTextField.isHidden = false
        inputView.formTextView.inputTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter title",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.7),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)
            ]
        )
        
        return inputView
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.setTitle("Save Task", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerCurve = .continuous
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        button.tapFeedback()
        return button
    }()
    
    // MARK: - INITIALIZER
    
    init(homeViewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.homeViewModel = homeViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //:
    
    // MARK: MAIN -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(taskInputView)
        view.addSubview(actionButton)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            taskInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskInputView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            taskInputView.heightAnchor.constraint(equalToConstant: 70),
            
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: ACTIONS -
    
    @objc func actionButtonTapped(){
        
        guard let homeViewModel else {
            // show alert if needed
            return
        }
        
        let text = taskInputView.formTextView.inputTextField.text ?? ""
        
        if text == "" {
            // show alert if needed
            return
        }
        
        // add task
        
        let taskData = HomeModel(taskName: text, timestamp: Date(), taskStatus: 0)
        homeViewModel.saveTask(modelData: taskData)
        
        self.dismiss(animated: true)
        self.updateCallback?()
        
    }

}
