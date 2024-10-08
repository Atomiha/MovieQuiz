//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Михаил Атоян on 16.09.2024.
//

import Foundation


//struct QuizQuestion {
//    // строка с названием фильма,
//    // совпадает с названием картинки афиши фильма в Assets
//    let image: String
//    // строка с вопросом о рейтинге фильма
//    let text: String
//    // булевое значение (true, false), правильный ответ на вопрос
//    let correctAnswer: Bool
//}
struct QuizQuestion {
    let image: Data
    let text: String
    let correctAnswer: Bool
}
