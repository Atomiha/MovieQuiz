//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Михаил Атоян on 21.09.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
