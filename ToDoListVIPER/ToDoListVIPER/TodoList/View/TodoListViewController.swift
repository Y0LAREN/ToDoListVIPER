//
//  TodoListViewController.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 27.03.2025.
//

import UIKit
import Foundation
import CoreData

final class TodoListViewController: UIViewController, TodoListViewProtocol {
    
    var presenter: TodoListPresenterProtocol?
    private var updateFooter: (() -> Void)?
    
    private let tableView = UITableView()
    private lazy var footerView: FooterView = {
        let footerView = FooterView()
        footerView.fetchedResults = presenter?.getNSFetchedResultsController()
        self.updateFooter = footerView.updateTodoCountLabel
        return footerView
    }()
    private let searchBarView = SearchBarView()
    private lazy var mainLabel = MainLabelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFooter?()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchTodos()
        self.footerView.todoCount = presenter?.getCountTodo() ?? 0
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

//MARK: - UITableViewDataSource
extension TodoListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //FIXME: - Возможно это не правильно -
        guard let count = presenter?.getNSFetchedResultsController()?.fetchedObjects?.count else { return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = (tableView.dequeueReusableCell(withIdentifier: "todoCellIdentifier", for: indexPath) as? TodoCell)
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCellIdentifier", for: indexPath)
            return cell
        }
        
        guard let todoEntity = presenter?.getNSFetchedResultsController()?.object(at: indexPath) else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCellIdentifier", for: indexPath)
            return cell
        }
        
        let todo = TodoItem(
            id: Int(todoEntity.id),
            todo: todoEntity.todo ?? "",
            completed: todoEntity.completed,
            userId: Int(todoEntity.userId),
            title: todoEntity.title,
            date: todoEntity.date)
        
        return setupCell(cell: cell, todo: todo)
    }
}

//MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let todoEntity = presenter?.getNSFetchedResultsController()?.object(at: indexPath) else { return nil }
        let todo = TodoItem(
            id: Int(todoEntity.id),
            todo: todoEntity.todo ?? "",
            completed: todoEntity.completed,
            userId: Int(todoEntity.userId),
            title: todoEntity.title,
            date: todoEntity.date)
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self.presenter?.goToTodo(todo: todo)
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.shareTodo(todo)
            }
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.presenter?.deleteTodo(todo)
                self.footerView.todoCount = self.presenter?.getCountTodo() ?? 0
            }
            
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TodoCell,
              let todo = cell.todoItem else {
            return
        }
        
        presenter?.goToTodo(todo: todo)
    }
}

//MARK: - Private methods
private extension TodoListViewController {
    func setupCell(cell: TodoCell, todo: TodoItem) -> TodoCell {
        
        switch todo.completed {
            case true:
                cell.configureCompleted(with: todo, onCheckmarkTapped: { [weak self] updatedTodo in
                    guard let self = self else { return }
                    self.presenter?.editTodoState(todo: updatedTodo)
                    cell.updateCompletedTodo(todo: updatedTodo)
                })
            case false:
                cell.configureIncomplete(with: todo, onCheckmarkTapped: { [weak self] updatedTodo in
                    guard let self = self else { return }
                    self.presenter?.editTodoState(todo: updatedTodo)
                })
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func shareTodo(_ todo: TodoItem) {
        let text = "\(todo.todo)\n \(todo.completed ? "Выполнено" : "Не выполнено")"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityVC, animated: true)
    }
}

// MARK: - SearchBar Delegate (Фильтрация)
extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            presenter?.updatePredicate(nil)
        } else {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR todo CONTAINS[cd] %@", searchText, searchText)
            presenter?.updatePredicate(predicate)
        }
        tableView.reloadData()
        updateFooter?()
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TodoListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? TodoCell {
                guard let todoEntity = presenter?.getNSFetchedResultsController()?.object(at: indexPath) else { return }
                let todo = TodoItem(
                    id: Int(todoEntity.id),
                    todo: todoEntity.todo ?? "",
                    completed: todoEntity.completed,
                    userId: Int(todoEntity.userId),
                    title: todoEntity.title,
                    date: todoEntity.date
                )
                _ = setupCell(cell: cell, todo: todo)
            }
        case .move:
                break
        @unknown default:
            fatalError("Неизвестный тип обновления в NSFetchedResultsControllerDelegate")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        updateFooter?()
    }
}

//MARK: - Setup UI
private extension TodoListViewController {
    func setupUI() {
        view.backgroundColor = .black
        
        setupMainLabel()
        setupSearchBarView()
        setupFooterView()
        setupTableView()
    }
    
    func setupMainLabel(){
        view.addSubview(mainLabel)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func setupSearchBarView(){
        view.addSubview(searchBarView)
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        
        if let searchBar = searchBarView.subviews.first as? UISearchBar {
            searchBar.delegate = self
        }
        
        NSLayoutConstraint.activate([
            searchBarView.heightAnchor.constraint(equalToConstant: 52),
            searchBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBarView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor)
        ])
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.rowHeight = 110
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.todoCellIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor)
        ])
    }
    
    func setupFooterView(){
        view.addSubview(footerView)
        
        footerView.translatesAutoresizingMaskIntoConstraints = false
        guard let todo = self.presenter?.getNSFetchedResultsController()?.fetchedObjects?.count else { return }
        footerView.addButtonClosure = {
            self.presenter?.addTodo(todoId: (todo + 1))
        }
        
        NSLayoutConstraint.activate([
            footerView.heightAnchor.constraint(equalToConstant: 80),
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

