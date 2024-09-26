//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Михаил Атоян on 25.09.2024.
//

import Foundation

struct GameResult: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        return self.correct * another.total >= self.total * another.correct
    }
}
