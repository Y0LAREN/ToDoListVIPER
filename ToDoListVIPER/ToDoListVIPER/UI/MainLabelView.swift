//
//  MainLabelView.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 26.03.2025.
//

import UIKit

final class MainLabelView: UIView {
    private lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.font = UIFont.boldSystemFont(ofSize: 34)
        mainLabel.textColor = .white
        mainLabel.text = "Задачи"
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        return mainLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MainLabelView {
    func setupUI() {
        backgroundColor = .black
        
        setupMainLabel()
    }
    
    func setupMainLabel(){
        addSubview(mainLabel)
        
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            mainLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
        ])
    }
}

