//
//  HomeViewController.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: PROPERTIES -
    
    var homeViewModel = HomeViewModel()
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.headerTitle.text = "My Task"
        view.headerTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        view.actionButton.setImage(UIImage(systemName: "plus"), for: .normal)
        view.actionButton.imageView?.tintColor = .black
        view.actionButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        
        
        return view
    }()
    
    lazy var taskTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    // MARK: MAIN -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .white
        view.addSubview(headerView)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func fetchData(){
        
        Task {
            do {
                let result = try await homeViewModel.getTasks()
                
                switch result {
                case .success(_):
                    
                    let tasks = homeViewModel.tasks
                    print("=== *** ===")
                    for task in tasks {
                        print("TASK NAME: \(task.taskName ?? "")")
                    }
                    
                case let .failure(error):
                    print(error)
                }
                
            } catch {
                
            }
        }
        
        
    }
    
    // MARK: ACTIONS -
    
    @objc func addTask(){
        
        let taskController = TasksViewController(homeViewModel: homeViewModel)
        taskController.modalPresentationStyle = .formSheet
        
        taskController.sheetPresentationController?.detents = [.medium()]
        taskController.sheetPresentationController?.prefersGrabberVisible = true
        
        taskController.updateCallback = { [weak self] in
            guard let self else { return }
            self.fetchData()
        }
        
        self.present(taskController, animated: true)
        
    }

}
