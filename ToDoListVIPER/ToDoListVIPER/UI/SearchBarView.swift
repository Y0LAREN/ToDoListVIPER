//
//  SearchBarView.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 26.03.2025.
//


import UIKit

final class SearchBarView: UIView {

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .darkGray
        searchBar.tintColor = .lightGray
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        return searchBar
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureSearchBar()
        addDoneButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        configureSearchBar()
    }
}

//MARK: - Private methods
private extension SearchBarView {
    func addDoneButton(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        searchBar.inputAccessoryView = toolbar
    }

    func setupUI() {
        addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureSearchBar() {
        guard let textField = searchBar.value(forKey: "searchField") as? UITextField else { return }
        
        textField.backgroundColor = UIColor(white: 0.15, alpha: 1)
        textField.textColor = .white
        textField.leftView?.tintColor = .lightGray
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray]
        textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributes)
    }
    
    @objc
    func dismissKeyboard() {
        self.endEditing(true)
    }
}

