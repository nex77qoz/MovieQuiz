//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Максим Бабкин on 28.07.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)    
}
