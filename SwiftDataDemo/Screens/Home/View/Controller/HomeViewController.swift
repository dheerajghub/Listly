//
//  HomeViewController.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: PROPERTIES -
    
    var homeViewModel = TaskViewModel()
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.headerTitle.text = "My Task"
        view.headerTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        
        let actionButton = view.trailingActionButton
        actionButton.isHidden = false
        actionButton.setImage(UIImage(named: "ic_archiv")?.withRenderingMode(.alwaysTemplate), for: .normal)
        actionButton.imageView?.tintColor = .black
        actionButton.addTarget(self, action: #selector(archivTapped), for: .touchUpInside)
        actionButton.backgroundColor = .clear
        actionButton.layer.cornerRadius = 20
        
        return view
    }()
    
    lazy var taskTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = true
        tableView.delaysContentTouches = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: windowConstant.getBottomPadding + 70 , right: 0)
        return tableView
    }()
    
    lazy var addTaskButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.tintColor = .white
        button.setTitle(" Add Task", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerCurve = .continuous
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        button.tapFeedback()
        button.dropShadow()
        return button
    }()
    
    lazy var defaultView: CustomDefaultView = {
        let view = CustomDefaultView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.defaultImageView.image = UIImage(named: "ic_add_task")
        view.defaultTitleLabel.text = "Turning 'to-do' into 'ta-da!' with every task."
        view.defaultActionButton.setTitle("Add your first task!", for: .normal)
        view.defaultActionButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        view.isHidden = true
        return view
    }()
    
    // MARK: MAIN -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        fetchData()
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(taskTableView)
        view.addSubview(addTaskButton)
        view.addSubview(defaultView)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addTaskButton.heightAnchor.constraint(equalToConstant: 50),
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            defaultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            defaultView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
    }
    
    func fetchData(){
        Task {
            do {
                let result = try await homeViewModel.getTasks()
                switch result {
                case .success(_):
                    let taskLeft = homeViewModel.tasks.count
                    if taskLeft == 0 {
                        // unhide default view
                        defaultView.isHidden = false
                        addTaskButton.isHidden = true
                    } else {
                        // hide default view
                        defaultView.isHidden = true
                        addTaskButton.isHidden = false
                    }
                    DispatchQueue.main.async {
                        self.taskTableView.reloadData()
                    }
                    
                case let .failure(error):
                    print(error)
                }
            } catch {}
        }
    }
    
    // MARK: ACTIONS -
    
    @objc func addTask(){
        
        
        homeViewModel.isEditing = false
        homeViewModel.editableTaskIndex = nil
        
        let taskController = TasksViewController(homeViewModel: homeViewModel)
        taskController.modalPresentationStyle = .overCurrentContext
        taskController.modalTransitionStyle = .crossDissolve
        
        taskController.updateCallback = { [weak self] in
            guard let self else { return }
            self.fetchData()
            // scroll to very bottom
            let taskCount = homeViewModel.tasks.count
            if  taskCount > 0 {
                let index = IndexPath(row: taskCount - 1, section: 0)
                self.taskTableView.scrollToRow(at: index, at: .bottom, animated: true)
            }
        }
        
        self.present(taskController, animated: true)
        
    }
    
    @objc func archivTapped(){
        
        let controller = ArchivedTaskViewController()
        controller.taskViewModel = homeViewModel
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

}

@available(iOS 17.0, *)
#Preview {
    let controller = HomeViewController()
    return controller
}
