//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Максим Бабкин on 28.07.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)    
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    func showLoadingIndicator() // New Method
    func hideLoadingIndicator() // New Method
}
