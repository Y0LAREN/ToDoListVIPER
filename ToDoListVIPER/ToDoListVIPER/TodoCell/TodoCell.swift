//
//  TodoCell.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 26.03.2025.
//


import UIKit

final class TodoCell: UITableViewCell {
    //MARK: Properties
    static let todoCellIdentifier = "todoCellIdentifier"
    var todoItem: TodoItem?
    var onCheckmarkTapped: ((TodoItem) -> Void)?
    var saveTodo: ((TodoItem) -> Void)?
    
    //MARK: UI
    lazy var checkmarkImageView = UIImageView()
    lazy var titleLabel = UILabel()
    lazy var descriptionLabel = UILabel()
    lazy var dateLabel = UILabel()
    
    lazy private var hStackView = UIStackView()
    lazy private var vStackView = UIStackView()
    
    //MARK: Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Override methods
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let checkmarkPoint = checkmarkImageView.convert(point, from: self)
        if checkmarkImageView.bounds.contains(checkmarkPoint) {
            return checkmarkImageView
        }
        return super.hitTest(point, with: event)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.attributedText = nil
        descriptionLabel.attributedText = nil
        dateLabel.text = nil
        
        checkmarkImageView.image = UIImage(systemName: "circle")
        checkmarkImageView.tintColor = .gray
        
        todoItem = nil
        onCheckmarkTapped = nil
    }
}

//MARK: - Configure Cell methods
extension TodoCell {
    
    func configureIncomplete(with todo: TodoItem, onCheckmarkTapped: @escaping (TodoItem) -> Void) {
        self.todoItem = todo
        self.onCheckmarkTapped = onCheckmarkTapped
        
        updateIncompletedTodo(todo: todo)
    }
    
    func configureCompleted(with todo: TodoItem, onCheckmarkTapped: @escaping (TodoItem) -> Void) {
        self.todoItem = todo
        self.onCheckmarkTapped = onCheckmarkTapped
        
        updateCompletedTodo(todo: todo)
    }
}

//MARK: - Update Cell methods
extension TodoCell{
    
    func updateIncompletedTodo(todo: TodoItem){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        
        checkmarkImageView.image = UIImage(systemName: "circle")
        checkmarkImageView.tintColor = .gray
        
        descriptionLabel.attributedText = plainAttributedString(from: todo.todo)
        descriptionLabel.textColor = .white
        
        titleLabel.attributedText = plainAttributedString(from: todo.title)
        titleLabel.textColor = .white
        
        guard let date = todo.date else { return }
        dateLabel.text = formatter.string(from: date)
    }
    
    func updateCompletedTodo(todo: TodoItem){
        let attributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.gray
        ]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle")
        checkmarkImageView.tintColor = .systemYellow
        
        if todo.title == nil {
            descriptionLabel.attributedText = NSAttributedString(string: todo.todo, attributes: attributes)
            descriptionLabel.textColor = .gray
        }
        else {
            titleLabel.attributedText = NSAttributedString(string: todo.title ?? "", attributes: attributes)
            titleLabel.textColor = .gray
            
            descriptionLabel.attributedText = nil
            descriptionLabel.attributedText = plainAttributedString(from: todo.todo)
            descriptionLabel.textColor = .gray
        }
        
        guard let date = todo.date else { return }
        dateLabel.text = formatter.string(from: date)
    }
}
//MARK: - Setup UI methods
private extension TodoCell {
    
    func setupUI() {
        backgroundColor = .black
        
        addSubview(hStackView)
        
        setupCheckmarkImageView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupDateLabel()
        setupVStackView()
        setupHStackView()
    }
    
    func setupCheckmarkImageView(){
        checkmarkImageView.isUserInteractionEnabled = true
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkmarkTapped))
        checkmarkImageView.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 25),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func setupTitleLabel(){
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func setupDescriptionLabel(){
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 2
    }
    
    func setupDateLabel(){
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray
    }
    
    func setupHStackView(){
        hStackView.addArrangedSubview(checkmarkImageView)
        hStackView.addArrangedSubview(vStackView)
        
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.spacing = 10
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            
            hStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            hStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            hStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            hStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setupVStackView(){
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(descriptionLabel)
        vStackView.addArrangedSubview(dateLabel)
        
        vStackView.axis = .vertical
        vStackView.spacing = 10
        vStackView.alignment = .leading
        vStackView.distribution = .fill
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.isUserInteractionEnabled = true
        
    }
}

//MARK: - Private methods
private extension TodoCell {
    
    @objc
    func checkmarkTapped() {
        guard let todo = todoItem else { return }
        todoItem = TodoItem(
            id: todo.id,
            todo: todo.todo,
            completed: !todo.completed,
            userId: todo.userId,
            title: todo.title,
            date: todo.date)
        
        guard let todoItem = todoItem else { return }
        onCheckmarkTapped?(todoItem)
        
        todoItem.completed ? updateCompletedTodo(todo: todoItem) : updateIncompletedTodo(todo: todoItem)
        print("todoItem: \(todoItem)")
    }
    
    func plainAttributedString(from text: String?) -> NSAttributedString {
        return NSAttributedString(string: text ?? "")
    }
}
