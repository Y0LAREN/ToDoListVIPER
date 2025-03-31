//
//  FooterView.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 26.03.2025.
//


import UIKit
import CoreData

final class FooterView: UIView {
    var todoCount: Int = 0 {
        didSet {
            todoCountLabel.text = "\(todoCount) Задач"
        }
    }
    weak var fetchedResults: NSFetchedResultsController<TodoEntity>?
    var addButtonClosure: (() -> Void)?
    
    let todoCountLabel: UILabel = {
        let todoCountLabel = UILabel()
        todoCountLabel.textColor = .white
        todoCountLabel.translatesAutoresizingMaskIntoConstraints = false
        return todoCountLabel
    }()

    let addButton: UIButton = {
        let addButton = UIButton()
        let image = UIImage(systemName: "square.and.pencil")
        addButton.setImage(image, for: .normal)
        addButton.tintColor = .systemYellow
        addButton.translatesAutoresizingMaskIntoConstraints = false
        return addButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTodoCountLabel() {
        todoCountLabel.text = "\(fetchedResults?.sections?.first?.numberOfObjects ?? 0) Задач"
    }
}

private extension FooterView {
    func setupUI() {
        backgroundColor = .darkGray
        
        setupTodoCountLabel()
        setupAddButton()
    }
    
    func setupTodoCountLabel() {
        addSubview(todoCountLabel)
        todoCountLabel.text = "\(todoCount) Задач"
        todoCountLabel.text = "\(fetchedResults?.sections?.first?.numberOfObjects ?? 0) Задач"
        
        
        NSLayoutConstraint.activate([
            todoCountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            todoCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor )
        ])
    }
    
    func setupAddButton() {
        addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    @objc
    func addButtonAction() {
        addButtonClosure?()
    }
}
