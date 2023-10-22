//
//  ArchivedTaskViewController.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 14/10/23.
//

import UIKit

class ArchivedTaskViewController: UIViewController {

    // MARK: PROPERTIES -
    
    var taskViewModel: TaskViewModel? {
        didSet {
            loadData()
        }
    }
    
    var archiveViewModel = ArchiveViewModel()
    var bottomActionViewHeightConstraint: NSLayoutConstraint?
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.headerTitle.text = "Archived Task"
        view.headerTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        
        let backButton = view.leadingActionButton
        backButton.isHidden = false
        backButton.setImage(UIImage(named: "ic_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        return view
    }()
    
    lazy var archivedTaskTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ArchivedTaskTableViewCell.self, forCellReuseIdentifier: "ArchivedTaskTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = true
        tableView.delaysContentTouches = false
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = windowConstant.getBottomPadding + 60
        return tableView
    }()
    
    lazy var defaultView: CustomDefaultView = {
        let view = CustomDefaultView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.defaultTitleLabel.text = "You have no archived tasks in the list."
        view.defaultActionButton.setTitle("Go back!", for: .normal)
        view.defaultActionButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.isHidden = true
        return view
    }()
    
    lazy var editActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_edit")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.setTitle("  Edit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        button.tapFeedback()
        button.addTarget(self, action: #selector(editActionTapped), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        button.dropShadow()
        return button
    }()
    
    lazy var bottomActionView: CustomBottomActionStackView = {
        let view = CustomBottomActionStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // unarchive action button
        let unarchiveButton = view.actionButton1
        unarchiveButton.setImage(UIImage(named: "ic_unarchive")?.withRenderingMode(.alwaysTemplate), for: .normal)
        unarchiveButton.imageView?.tintColor = .white
        unarchiveButton.setTitle("  Unarchive", for: .normal)
        unarchiveButton.addTarget(self, action: #selector(unarchiveButtonTapped), for: .touchUpInside)
        
        
        // unarchive action button
        let cancelButton = view.actionButton2
        cancelButton.setImage(UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cancelButton.imageView?.tintColor = .white
        cancelButton.setTitle("  Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        return view
    }()
    
    // MARK: MAIN -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        setupDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(archivedTaskTableView)
        view.addSubview(defaultView)
        view.addSubview(editActionButton)
        view.addSubview(bottomActionView)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            archivedTaskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            archivedTaskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            archivedTaskTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            archivedTaskTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            defaultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            defaultView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            editActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            editActionButton.heightAnchor.constraint(equalToConstant: 50),
            editActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bottomActionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomActionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomActionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        bottomActionViewHeightConstraint = bottomActionView.heightAnchor.constraint(equalToConstant: 0)
        bottomActionViewHeightConstraint?.isActive = true
    }
    
    func loadData(){
        
        guard let taskViewModel else { return }
        Task {
            do {
                let result = try await taskViewModel.getTasks(isArchived: true)
                switch result {
                case .success(_):
                    let taskLeft = taskViewModel.tasks.count
                    if taskLeft == 0 {
                        // unhide default view
                        defaultView.isHidden = false
                        editActionButton.isHidden = true
                    } else {
                        // hide default view
                        defaultView.isHidden = true
                        editActionButton.isHidden = false
                    }
                    self.archivedTaskTableView.reloadData()
                    
                case let .failure(error):
                    print(error)
                }
            } catch {}
        }
        
    }
    
    func setupDefaults(){
        
        // can show error are you sure want to revert ?
        
        if !archiveViewModel.isEditing {
            // reverting the selection change back
            /// as they are temporary changes
            guard let taskViewModel else { return }
            let tasks = taskViewModel.tasks
            taskViewModel.updateTasks(tasks: tasks, isSelectedForEditing: false)
        }
    }
    
    func makeBottomActions(active: Bool){
        bottomActionViewHeightConstraint?.constant = active ? (windowConstant.getBottomPadding + 70) : 0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1) { [weak self] in
            guard let self else { return }
            self.editActionButton.transform = active ? .init(scaleX: 0.5, y: 0.5) : .identity
            self.editActionButton.alpha = active ? 0 : 1
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - ACTION
    
    @objc func backTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editActionTapped(){
        archiveViewModel.isEditing.toggle()
        setupDefaults()
        self.archivedTaskTableView.reloadData()
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1){ [weak self] in
            guard let self else { return }
            if self.archiveViewModel.isEditing {
                self.editActionButton.setTitle(" Cancel", for: .normal)
                self.editActionButton.setTitleColor(.white, for: .normal)
                self.editActionButton.backgroundColor = Colors.appRed
                self.editActionButton.setImage(UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate), for: .normal)
                self.editActionButton.imageView?.tintColor = .white
            } else {
                self.editActionButton.setTitle(" Edit", for: .normal)
                self.editActionButton.setTitleColor(.white, for: .normal)
                self.editActionButton.backgroundColor = .black
                self.editActionButton.setImage(UIImage(named: "ic_edit")?.withRenderingMode(.alwaysTemplate), for: .normal)
                self.editActionButton.imageView?.tintColor = .white
            }
        }
        
    }
    
    @objc func cancelButtonTapped(){
        makeBottomActions(active: false)
        editActionTapped()
    }
    
    @objc func unarchiveButtonTapped(){
        
        // unarchive the selected task
        guard let taskViewModel else { return }
        let toBeUnarchived = taskViewModel.tasks.filter { tasks in
            return tasks.isSelectedForEditing == true
        }
        
        taskViewModel.updateTasks(tasks: toBeUnarchived, isArchived: false)
        loadData()
        
        makeBottomActions(active: false)
        editActionTapped()
        
    }

}
