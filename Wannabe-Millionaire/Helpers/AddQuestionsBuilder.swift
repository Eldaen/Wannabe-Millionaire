//
//  addQuestionsBuilder.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 02.02.2022.
//

import Foundation
import UIKit

/// Билдер массива вопросов для добавления в программу
final class AddQuestionsBuilder {
	
	/// Массив вопросов
	var questions: [Question] = []
	
	/// Данные о завершении конфигурации вопросов
	var questionsCompletion: [Int: [String: Bool]] = [:]
	
	private var text: String?
	private var correctAnswer: String?
	private var answerTwo: String?
	private var answerThree: String?
	private var answerFour: String?
	
	func setText(_ text: String, index: Int) {
		checkValidIndex(index)
		questions[index].text = text
		complete(for: index, key: "text")
	}
	
	func setCorrectAnswer(_ text: String, index: Int) {
		checkValidIndex(index)
		
		questions[index].answerOptions.append(text)
		questions[index].correctAnswer = questions.count - 1
		
		configureClues(for: questions.count - 1)
		complete(for: index, key: "correctValue")
	}
	
	func setAnswerTwo(_ text: String, index: Int) {
		checkValidIndex(index)
		questions[index].answerOptions.append(text)
		complete(for: index, key: "answerTwo")
	}
	
	func setAnswerThree(_ text: String, index: Int) {
		checkValidIndex(index)
		questions[index].answerOptions.append(text)
		complete(for: index, key: "answerThree")
	}
	
	func setAnswerFour(_ text: String, index: Int) {
		checkValidIndex(index)
		questions[index].answerOptions.append(text)
		complete(for: index, key: "answerFour")
	}
	
	/// Возвращает массив собранных вопросов
	func build() -> [Question] {
		var completeQuestionsIds: [Int] = []
		
		for id in questionsCompletion {
			if id.value.count == 5 {
				completeQuestionsIds.append(id.key)
			}
		}
		
		return questions.filter { completeQuestionsIds.contains( $0.id ) }
	}
	
	/// Проверяет, есть ли уже вопрос с таким индексом, если нет - добавляет в массив пустой вопрос
	private func checkValidIndex(_ index: Int) {
		let isIndexValid = questions.indices.contains(index)
		
		if !isIndexValid {
			questions.append(createEmptyQuestion(with: index))
		}
	}
	
	/// Создаёт пустой вопрос
	private func createEmptyQuestion(with index: Int) -> Question {
		return Question(id: index,
						text: "",
						answerOptions: [],
						correctAnswer: -1,
						fiftyFiftyClue: [],
						callFriendClue: -1,
						hallHelp: HallHelpClue(
							full: [],
							half: []
						)
		)
	}
	
	/// Заполняет Question данными для подсказок
	private func configureClues(for index: Int) {
		var question = questions[index]
		let correctAnswer = question.correctAnswer
		
		question.fiftyFiftyClue = generateFiftyFiftyClue(for: correctAnswer)
		question.callFriendClue = generateCallFriendClue()
		question.hallHelp = generateHallHelpClue(correctAnswer: correctAnswer)
	}
	
	/// Генерирует рандомные подсказки 50 на 50
	private func generateFiftyFiftyClue(for index: Int) -> [Int] {
		let possibleAnswers = [0, 1, 2, 3].filter { $0 != index }
		var result: [Int] = []
		var previousElement = -1
		var count = 0
		
		while count < 2 {
			if let element = possibleAnswers.randomElement(), element != previousElement {
				previousElement = element
				result.append(element)
				count += 1
			}
		}
		
		return result
	}
	
	/// Генерирует данные для подсказки Помощь друга
	private func generateCallFriendClue() -> Int {
		return [0, 1, 2, 3].randomElement()!
	}
	
	/// Генерирует данные для подсказки Помощь Зала
	private func generateHallHelpClue(correctAnswer index: Int) -> HallHelpClue {
		let firstAnswerFull = Int.random(in: 0...100)
		let secondAnswerFull = Int.random(in: 0...(100 - firstAnswerFull))
		let thirdAnswerFull = Int.random(in: 0...(100 - firstAnswerFull - secondAnswerFull))
		let fourthAnswerFull = Int.random(in: 0...(100 - firstAnswerFull - secondAnswerFull - thirdAnswerFull))
		
		let full = [firstAnswerFull, secondAnswerFull, thirdAnswerFull, fourthAnswerFull]
		var half: [Int] = []
		
		let fiftyFifty = generateFiftyFiftyClue(for: index)
		
		
		for index in 0...3 {
			var firstResult: Int = 0
			
			if index == fiftyFifty[0] || index == fiftyFifty[1] {
				if half.isEmpty {
					half.append(Int.random(in: 0...100))
					firstResult = index
				} else {
					half.append(Int.random(in: 0...(100 - half[firstResult])))
				}
			}
			half.append(0)
		}
		
		return HallHelpClue(full: full, half: half)
	}
	
	func complete(for index: Int, key: String) {
		if let _ = questionsCompletion[index] {
			questionsCompletion[index]?.updateValue(true, forKey: key)
		} else {
			questionsCompletion.updateValue([key: true], forKey: index)
		}
	}
}
