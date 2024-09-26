//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Михаил Атоян on 23.09.2024.
//
import Foundation
import UIKit

class AlertPresenter {
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showAlert(model: AlertModel) {
        guard let delegate else {
            return
        }
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        delegate.present(alert, animated: true, completion: nil)
    }
}
