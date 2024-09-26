//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Михаил Атоян on 25.09.2024.
//

import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case total
        case totalAccuracy
    }
}

extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            guard let data = storage.data(forKey: Keys.bestGame.rawValue),
                  let game = try? JSONDecoder().decode(GameResult.self, from: data)  else {
                return GameResult(correct: 0, total: 0, date: Date())
            }
            return game
        }
        
        set {
            guard let data = try? encoder.encode(newValue) else {
                return
            }
            
            storage.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    private var correct: Int {
        get {
            return storage.integer(forKey: Keys.correct.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    private var total: Int {
        get {
            return storage.integer(forKey: Keys.total.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    var totalAccuracy: Double {
        get {
            return Double(correct) / Double(total)
        }
        set {
            storage.set(newValue, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        correct += count
        total += amount
        gamesCount += 1
        
        let newGame = GameResult(correct: count, total: amount, date: Date())
        if newGame.isBetterThan(bestGame) {
            bestGame = newGame
        }
        
    }
}
