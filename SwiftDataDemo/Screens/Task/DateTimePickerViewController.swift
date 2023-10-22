//
//  DateTimePickerViewController.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 21/10/23.
//

import UIKit

class DateTimePickerViewController: UIViewController {

    // MARK: PROPERTIES -
    
    var updateCallback: ((Date?) -> ())?
    
    var selectedDate: Date? {
        didSet {
            guard let selectedDate else {
                datePreviewLabel.text = datePicker.date.dueOnFormat()
                return
            }
            
            datePreviewLabel.text = selectedDate.dueOnFormat()
        }
    }
    
    let headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.headerTitle.text = "Due For"
        view.headerTitle.font = .systemFont(ofSize: 18, weight: .bold)
        
        return view
    }()
    
    let datePreviewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let datePreviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    // Date picker
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .inline
        datePicker.tintColor = .black
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        return datePicker
    }()
    
    //:
    
    // Bottom action stack
    
    lazy var bottomActionView: CustomBottomActionStackView = {
        let view = CustomBottomActionStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // done action button
        let doneButton = view.actionButton2
        doneButton.setImage(UIImage(named: "ic_check")?.withRenderingMode(.alwaysTemplate), for: .normal)
        doneButton.imageView?.tintColor = .white
        doneButton.setTitle("  Done", for: .normal)
        doneButton.backgroundColor = .black
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        // cancel action button
        let clearButton = view.actionButton1
        clearButton.setImage(UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.imageView?.tintColor = .white
        clearButton.setTitle("  Clear", for: .normal)
        clearButton.backgroundColor = Colors.appRed
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        
        return view
    }()
    
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
        
        view.addSubview(datePreviewView)
        datePreviewView.addSubview(datePreviewLabel)
        datePreviewView.addSubview(dividerView)
        
        view.addSubview(dividerView)
        view.addSubview(datePicker)
        
        view.addSubview(bottomActionView)
    }
    
    func setUpConstraints(){
        
        datePreviewLabel.pin(to: datePreviewView)
        NSLayoutConstraint.activate([
            
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            datePreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePreviewView.heightAnchor.constraint(equalToConstant: 55),
            datePreviewView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: datePreviewView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: datePreviewView.trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: datePreviewView.bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            datePicker.bottomAnchor.constraint(equalTo: bottomActionView.topAnchor),
            datePicker.topAnchor.constraint(equalTo: datePreviewView.bottomAnchor),
            
            bottomActionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomActionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomActionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomActionView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    // MARK: - ACTIONS
    
    @objc func datePickerChanged(){
        selectedDate = datePicker.date
    }
    
    @objc func doneButtonTapped(){
        updateCallback?(selectedDate)
        self.dismiss(animated: true)
    }
    
    @objc func clearButtonTapped(){
        selectedDate = nil
        updateCallback?(selectedDate)
        self.dismiss(animated: true)
    }

}


@available(iOS 17.0, *)
#Preview {
    let dateTimeController = DateTimePickerViewController()
    return dateTimeController
}
