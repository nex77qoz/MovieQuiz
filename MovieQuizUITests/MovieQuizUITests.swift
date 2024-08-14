//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Максим Бабкин on 11.08.2024.
//

import XCTest

class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = true
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    func testYesButton() {
        let indexLabel = app.staticTexts["Index"]
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        XCTAssertEqual(indexLabel.label, "1/10")

        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertEqual(indexLabel.label, "2/10")
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    func testNoButton() {
        let indexLabel = app.staticTexts["Index"]
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        XCTAssertEqual(indexLabel.label, "1/10")

        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertEqual(indexLabel.label, "2/10")
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    func testShowFinishAlert() {
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(1)
        }
        let alert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    func testCloseAlert() {
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(1)
        }
        sleep(2)
        app.alerts["Этот раунд окончен!"].scrollViews.otherElements.buttons["Сыграть ещё раз"].press(forDuration: 0.2)
        sleep(2)
        XCTAssertFalse(app.alerts["Этот раунд окончен!"].exists)
        XCTAssertEqual(app.staticTexts["Index"].label, "1/10")
    }
}
