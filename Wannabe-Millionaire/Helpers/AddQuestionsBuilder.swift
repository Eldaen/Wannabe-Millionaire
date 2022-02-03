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
	
	/// ENUM ключей для названия полей ввода данных вопроса
	enum fieldsKeys: String {
		case text
		case correctAnswer
		case first
		case second
		case third
		case fourth
	}
	
	/// ENUM ключей для ввода данных заполненности вопроса перед генерацией
	enum CompletionKeys: String {
		case text
		case correctValue
		case answerTwo
		case answerThree
		case answerFour
	}
	
	/// Массив вопросов
	var questions: [Int: [String : String]] = [:]
	
	/// Данные о завершении конфигурации вопросов
	var questionsCompletion: [Int: [String: Bool]] = [:]
	
	func setText(_ text: String, index: Int) {
		addText(for: index, key: .text, text: text)
		complete(for: index, key: .text)
	}
	
	func setCorrectAnswer(_ text: String, index: Int) {
		addText(for: index, key: .first, text: text)
		addText(for: index, key: .correctAnswer, text: String(questions.count - 1))
		complete(for: index, key: .correctValue)
	}
	
	func setAnswerTwo(_ text: String, index: Int) {
		addText(for: index, key: .second, text: text)
		complete(for: index, key: .answerTwo)
	}
	
	func setAnswerThree(_ text: String, index: Int) {
		addText(for: index, key: .third, text: text)
		complete(for: index, key: .answerThree)
	}
	
	func setAnswerFour(_ text: String, index: Int) {
		addText(for: index, key: .fourth, text: text)
		complete(for: index, key: .answerFour)
	}
	
	/// Возвращает массив собранных вопросов
	func build() -> [Question] {
		var completeQuestionsIds: [Int] = []
		
		for id in questionsCompletion {
			if id.value.count == 5 {
				completeQuestionsIds.append(id.key)
			}
		}
		
		let filtered = questions.filter { completeQuestionsIds.contains( $0.key ) }
		let questionObjects = generateQuestions(using: filtered)
		let shuffled = shuffleOptions(for: questionObjects)
		
		return shuffled.map { configureClues(for: $0) }
	}
	
}

// MARK: - Private methods

private extension AddQuestionsBuilder {
	
	/// Создаёт пустой вопрос
	func createEmptyQuestion(with index: Int) -> Question {
		return Question(id: Int.random(in: 1000...10000),
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
	func configureClues(for question: Question) -> Question {
		var result = question
		let correctAnswer = question.correctAnswer
		
		result.fiftyFiftyClue = generateFiftyFiftyClue(for: correctAnswer)
		result.callFriendClue = generateCallFriendClue()
		result.hallHelp = generateHallHelpClue(correctAnswer: correctAnswer)
		
		return result
	}
	
	/// Генерирует рандомные подсказки 50 на 50
	func generateFiftyFiftyClue(for index: Int) -> [Int] {
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
	func generateCallFriendClue() -> Int {
		return [0, 1, 2, 3].randomElement()!
	}
	
	/// Генерирует данные для подсказки Помощь Зала
	func generateHallHelpClue(correctAnswer index: Int) -> HallHelpClue {
		let firstAnswerFull = Int.random(in: 0...100)
		let secondAnswerFull = Int.random(in: 0...(100 - firstAnswerFull))
		let thirdAnswerFull = Int.random(in: 0...(100 - firstAnswerFull - secondAnswerFull))
		let fourthAnswerFull = 100 - firstAnswerFull - secondAnswerFull - thirdAnswerFull
		
		let full = [firstAnswerFull, secondAnswerFull, thirdAnswerFull, fourthAnswerFull].shuffled()
		var half: [Int] = []
		
		let fiftyFifty = generateFiftyFiftyClue(for: index)
		
		var firstResult: Int = -1
		for index in 0...3 {
			
			if index != fiftyFifty[0] && index != fiftyFifty[1] {
				if firstResult == -1 {
					half.append(Int.random(in: 0...100))
					firstResult = half[index]
				} else {
					half.append(100 - firstResult)
				}
				continue
			}
			half.append(0)
		}
		
		return HallHelpClue(full: full, half: half)
	}
	
	/// Генерирует массив объектов Question из переданных данных
	func generateQuestions(using data: [Int: [String : String]]) -> [Question] {
		var result: [Question] = []
		
		for question in data {
			let questionObject = Question(id: Int.random(in: 1000...10000),
										  text: question.value[fieldsKeys.text.rawValue] ?? "",
							  answerOptions: [
								question.value[fieldsKeys.first.rawValue] ?? "",
								question.value[fieldsKeys.second.rawValue] ?? "",
								question.value[fieldsKeys.third.rawValue] ?? "",
								question.value[fieldsKeys.fourth.rawValue] ?? "",
							  ],
							  correctAnswer: Int(question.value[fieldsKeys.correctAnswer.rawValue] ?? "0") ?? 0,
							  fiftyFiftyClue: [],
							  callFriendClue: -1,
							  hallHelp: HallHelpClue(
								  full: [],
								  half: []
							  )
			  )
			result.append(questionObject)
		}
		
		return result
	}
	
	/// записывает последнее изменение текста поля
	func addText(for index: Int, key: fieldsKeys, text: String) {
		if let _ = questions[index] {
			questions[index]?.updateValue(text, forKey: key.rawValue)
		} else {
			questions.updateValue([key.rawValue: text], forKey: index)
		}
	}
	
	/// Отмечает, что переданное по ключу поле было заполнено
	func complete(for index: Int, key: CompletionKeys) {
		if let _ = questionsCompletion[index] {
			questionsCompletion[index]?.updateValue(true, forKey: key.rawValue)
		} else {
			questionsCompletion.updateValue([key.rawValue: true], forKey: index)
		}
	}
	
	/// Перемешивает порядок ответов
	func shuffleOptions(for questions: [Question]) -> [Question] {
		var result = questions
		
		for (index, question) in questions.enumerated() {
			let correctAnswer = question.answerOptions[question.correctAnswer]
			result[index].answerOptions = question.answerOptions.shuffled()
			
			if let correctIndex = result[index].answerOptions.firstIndex(of: correctAnswer) {
				result[index].correctAnswer = correctIndex
			}
		}
		
		return result
	}
}
