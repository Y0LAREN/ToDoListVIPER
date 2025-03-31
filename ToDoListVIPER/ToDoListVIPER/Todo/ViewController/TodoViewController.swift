//
//  TodoViewController.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 28.03.2025.
//


import UIKit

final class TodoViewController: UIViewController {
    
    // MARK: - Properties
    var todo: TodoItem?
    var mode: TodoGoMode
    var presenter: TodoPresenterProtocol?
    var titleText: String?
    let placeholderForTextView: String = "Введите ваш текст..."
    
    // MARK: - UI
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.boldSystemFont(ofSize: 34)
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.placeholder = "Заголовок"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let todoTextView: UITextView = {
        let textView = UITextView()
        
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.borderStyle = .none
        textView.textColor = .white
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        textView.isScrollEnabled = true
        
        return textView
    }()
    
    // MARK: - Initializer
    init(todo: TodoItem?, mode: TodoGoMode) {
        self.todo = todo
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.checkTodoIsNil(checkIsEditing: isEditing())
        addDoneButton()
        setupUI()
        configureData()
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveTodo()
        guard let todo = todo, !emptyTodo()
        else { return }
        
        presenter?.viewWillDisappear(todo: todo)
    }
}

//MARK: - UI methods
private extension TodoViewController {
    func setupUI() {
        view.backgroundColor = .black
        
        setupTitleTextField()
        setupDateLabel()
        setupDescriptionTextField()
    }
    
    func setupTitleTextField() {
        view.addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func setupDateLabel() {
        view.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor)
        ])
    }
    
    func setupDescriptionTextField() {
        view.addSubview(todoTextView)
        
        todoTextView.delegate = self
        todoTextView.text = placeholderForTextView
        
        NSLayoutConstraint.activate([
            todoTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            todoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            todoTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            todoTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}

//MARK: - Private methods
private extension TodoViewController{
    
    func emptyTodo() -> Bool {
        if let textTitle = titleTextField.text,
           textTitle.isEmpty,
           let textTodo = todoTextView.text,
           textTodo.isEmpty
        {
            return true
        }
        return false
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .systemYellow
    }
    
    func configureData() {
        guard let todo = todo else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            dateLabel.text = formatter.string(from: Date())
            return
        }
        titleTextField.text = todo.title
        todoTextView.text = todo.todo
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        dateLabel.text = formatter.string(from: todo.date ?? Date())
    }
    
    func saveTodo() {
        guard let currentTodo = todo
        else { return }
        guard let text = titleTextField.text else {
            titleText = nil
            return
        }
        titleText = titleTextField.text
        if text.isEmpty {
            titleText = nil
        }
        
        todo = TodoItem(
            id: currentTodo.id,
            todo: todoTextView.text ?? "",
            completed: currentTodo.completed,
            userId: currentTodo.userId,
            title: titleText,
            date: Date())
    }
    
    func addDoneButton(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        toolbar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        todoTextView.inputAccessoryView = toolbar
        titleTextField.inputAccessoryView = toolbar
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - TodoViewProtocol methods
extension TodoViewController: TodoViewProtocol{
    func isEditing() -> Bool {
        if mode == .editTodo {
            return true
        }
        else {
            return false
        }
    }
}

//MARK: - UITextViewDelegate methods
extension TodoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderForTextView {
            textView.text = ""
        }
        textView.textColor = .white
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}

