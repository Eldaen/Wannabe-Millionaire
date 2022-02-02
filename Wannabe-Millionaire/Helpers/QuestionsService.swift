//
//  QuestionsService.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 26.01.2022.
//

import Foundation

/// Сервис загрузки вопросов
/// - По заданию нужно сделать это всё через паттерн Strategy, но мне тут так не нравится =(
/// - Один QuestionsService вполне мог бы отдавать вопросы как угодно вроде loadQuestions(state: .random)
final class QuestionsService {
	var questions: [Question] = []

	/// Cервис для загрузки сохранённых пользователем вопросов
	let caretaker = QuestionsCaretaker(key: "questions")
	
	/// Загружает вопросы последовательно
	func loadQuestions() -> [Question] {
		do {
			try readQuestionsFile()
		} catch {
			print(error)
		}
		
		if let userQuestions: [Question] = caretaker.resumeSession() {
			questions = questions + userQuestions
		}
		
		return questions
	}
	
	/// Загружает вопросы в случайном порядке
	func loadQuestionsRandom() -> [Question] {
		do {
			try readQuestionsFile()
			return questions.shuffled()
		} catch {
			print(error)
		}
		
		return []
	}
	
	/// Читает файл с вопросами
	private func readQuestionsFile() throws {
		if let filepath = Bundle.main.path(forResource: "questions", ofType: "json") {
			do {
				let contents = try Data(contentsOf: URL(fileURLWithPath: filepath))
				let decodedData = try JSONDecoder().decode([Question].self, from: contents)
				questions = decodedData
			} catch {
				print(error)
			}
		}
	}
}
