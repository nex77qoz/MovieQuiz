//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Максим Бабкин on 28.07.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
