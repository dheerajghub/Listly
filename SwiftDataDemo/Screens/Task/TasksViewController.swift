//
//  TasksViewController.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import UIKit

class TasksViewController: UIViewController {

    // MARK: PROPERTIES -
    
    var homeViewModel: TaskViewModel?
    var dueOn: Date?
    var updateCallback: (() -> Void)?
    var bottomConstraint: NSLayoutConstraint?
    var taskTextViewHeightConstraint: NSLayoutConstraint?
    
    lazy var backCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    let contentCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.headerTitle.text = "Add Task"
        view.backgroundColor = .white
        view.headerTitle.font = .systemFont(ofSize: 15, weight: .semibold)
        
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
        
        return view
    }()
    
    lazy var taskTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 15, weight: .medium)
        
        textView.tintColor = .black
        textView.textColor = UIColor.lightGray
        textView.text = "e.g. My awesome task"
        textView.backgroundColor = .clear
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.returnKeyType = .done
        
        return textView
    }()
    
    lazy var bottomActionView: TaskActionView = {
        let view = TaskActionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    // MARK: - INITIALIZER
    
    init(homeViewModel: TaskViewModel) {
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillShowNotification , object: nil)
                
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillHideNotification , object: nil)
        
        setUpDefaults()
        
        taskTextViewHeightConstraint?.priority = .fittingSizeLevel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.backCoverView.alpha = 1
            self.backCoverView.backgroundColor = .black.withAlphaComponent(0.4)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.backCoverView.alpha = 0
            self.backCoverView.backgroundColor = .clear
        }
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .clear
        view.addSubview(backCoverView)
        
        view.addSubview(contentCoverView)
        view.addSubview(headerView)
        view.addSubview(taskTextView)
        
        view.addSubview(bottomActionView)
        
        hideKeyboardWhenTappedAround()
        
        // on appear it makes textView first responder
        taskTextView.becomeFirstResponder()
        taskTextView.selectedTextRange = taskTextView.textRange(from: taskTextView.beginningOfDocument, to: taskTextView.beginningOfDocument)
    }
    
    func setUpConstraints(){
        backCoverView.pin(to: view)
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 45),
            
            taskTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            taskTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13),
            taskTextView.bottomAnchor.constraint(equalTo: bottomActionView.topAnchor, constant: -10),
            taskTextView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            
            contentCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentCoverView.topAnchor.constraint(equalTo: headerView.topAnchor),
            
            bottomActionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomActionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomActionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomActionView.heightAnchor.constraint(equalToConstant: 60)
            
        ])
        
        //bottomconstraints
        bottomConstraint = NSLayoutConstraint(item: bottomActionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        taskTextViewHeightConstraint = taskTextView.heightAnchor.constraint(equalToConstant: 50)
        taskTextViewHeightConstraint?.isActive = true
        
    }
    
    func setUpDefaults(){
        
        guard let homeViewModel,
              let index = homeViewModel.editableTaskIndex
        else { return }
        
        headerView.headerTitle.text = "Update Task"
        
        let task = homeViewModel.tasks[index]
        taskTextView.text = task.taskName
        taskTextView.textColor = .black
        
        self.updateBottomUI(task.dueOn)
        self.textViewDidChange(self.taskTextView)
        
        
    }
    
    func updateBottomUI(_ date: Date?){
        let dueOnButton = self.bottomActionView.dueActionButton
        if let date {
            let dueOnDate = date.dueOnFormat()
            dueOnButton.setTitle(" \(dueOnDate)", for: .normal)
            dueOnButton.setTitleColor(.black, for: .normal)
            dueOnButton.layer.borderColor = UIColor.black.cgColor
            dueOnButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        } else {
            dueOnButton.setTitle("Due", for: .normal)
            dueOnButton.setTitleColor(.lightGray, for: .normal)
            dueOnButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
            dueOnButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        }
    }
    
    // MARK: ACTIONS -
    
    @objc func handleKeyboardNotification(notification: NSNotification){
            
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardHeight : -(windowConstant.getBottomPadding)
            
            UIView.animate(withDuration:0.1, delay: 0 , options: .curveEaseOut , animations: {
                self.view.layoutIfNeeded()
            } , completion: {(completed) in
            })
        }
    }
    
    @objc func dismissController(){
        
        if taskTextView.text != "" && taskTextView.text != "e.g. My awesome task" && !taskTextView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            Helper.showAlert(message: "Are you sure want to discard this task?", controller: self, alertType: .default) { success in
                if success {
                    self.dismiss(animated: true)
                }
            }
        } else {
            self.dismiss(animated: true)
        }
        
    }

}

@available(iOS 17.0, *)
#Preview {
    let controller = TasksViewController(homeViewModel: TaskViewModel())
    return controller
}
