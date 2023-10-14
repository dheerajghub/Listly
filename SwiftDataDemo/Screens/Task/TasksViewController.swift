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
        view.actionStackView.isHidden = true
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
        textView.returnKeyType = .done
        
        return textView
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerCurve = .continuous
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        button.tapFeedback()
        button.isEnabled = false
        button.alpha = 0.3
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
        view.addSubview(actionButton)
        
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
            taskTextView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -10),
            taskTextView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
            contentCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentCoverView.topAnchor.constraint(equalTo: headerView.topAnchor)
        ])
        
        //bottomconstraints
        bottomConstraint = NSLayoutConstraint(item: actionButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        taskTextViewHeightConstraint = taskTextView.heightAnchor.constraint(equalToConstant: 50)
        taskTextViewHeightConstraint?.isActive = true
        
    }
    
    func setUpDefaults(){
        
        guard let homeViewModel,
              let index = homeViewModel.editableTaskIndex
        else { return }
        
        headerView.headerTitle.text = "Update Task"
        
        let task = homeViewModel.tasks[index].taskName
        taskTextView.text = task
        taskTextView.textColor = .black
        self.textViewDidChange(self.taskTextView)
        
        
    }
    
    // MARK: ACTIONS -
    
    @objc func actionButtonTapped(){
        
        guard let homeViewModel else {
            // show alert if needed
            return
        }
        
        let text = taskTextView.text ?? ""
        
        if text == "" || text == "e.g. My awesome task" || taskTextView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            // show alert if needed
            return
        }
        
        // update task
        if homeViewModel.isEditing {
            guard let index = homeViewModel.editableTaskIndex else { return }
            let currentTask = homeViewModel.tasks[index]
            currentTask.taskName = text
            homeViewModel.updateTask(task: currentTask)
        } else {
            
            // get total count of tasks
            let totalTask = homeViewModel.tasks.count
            let taskData = HomeModel(taskName: text, orderNum: totalTask + 1)
            homeViewModel.saveTask(modelData: taskData)
        }
        
        
        self.dismiss(animated: true)
        self.updateCallback?()
        
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
            
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyboardShowing ? -(keyboardHeight + 10) : 10
            
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

extension TasksViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: taskTextView.frame.width , height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        if estimatedSize.height < 50.0 {
            self.taskTextViewHeightConstraint?.constant = 50
        } else {
            self.taskTextViewHeightConstraint?.constant = estimatedSize.height
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        
        if textView.text == "" || textView.text == "e.g. My awesome task" || taskTextView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            // show alert if needed
            actionButton.isEnabled = false
            actionButton.alpha = 0.3
        } else {
            actionButton.isEnabled = true
            actionButton.alpha = 1
        }
        
        print("ESTIMATED HEIGHT ::\(estimatedSize.height)")
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        
        // dismiss the keyboard if newline character typed
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        
        if updatedText.isEmpty {
            textView.text = "e.g. My awesome task"
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
}
