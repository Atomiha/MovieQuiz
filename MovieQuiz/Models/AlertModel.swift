//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Михаил Атоян on 23.09.2024.
//

import Foundation
import UIKit


struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
