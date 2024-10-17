//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Михаил Атоян on 05.10.2024.
//

import Foundation
protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
/// Отвечает за загрузку данных по URL
struct NetworkClient: NetworkRouting {

    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
               !(200..<300 ~= response.statusCode)  {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
