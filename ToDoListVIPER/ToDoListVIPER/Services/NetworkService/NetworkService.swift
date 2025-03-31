//
//  NetworkService.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 26.03.2025.
//

import Foundation

final class NetworkService {

    static let shared = NetworkService()

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        let task = session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(TodoResponse.self, from: data)
                completion(.success(decoded.todos))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

