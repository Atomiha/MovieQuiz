//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Михаил Атоян on 17.10.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    private var currentQuestionIndex = 0
    let questionsAmount = 10
    
    func isLastQuestion() -> Bool {
        return currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex(){
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}
