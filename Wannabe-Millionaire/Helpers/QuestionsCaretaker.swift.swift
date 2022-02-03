//
//  QuestionsCaretaker.swift.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 02.02.2022.
//

import Foundation

/// Сaretaker для пользовательских новостей
final class QuestionsCaretaker {
	
	private let encoder = JSONEncoder()
	private let decoder = JSONDecoder()
	
	/// Ключ для записи в UserDefaults
	private let key: String
	
	init(key: String) {
		self.key = key
	}
	
	/// Сохраняет сессию
	func save(_ questions: [Question]) {
		do {
			let data = try self.encoder.encode(questions)
			UserDefaults.standard.set(data, forKey: key)
		} catch {
			print(error)
		}
	}
	
	func addQuestions(_ questions: [Question]) {
		var questionsArray = questions
		
		if let oldQuestions = resumeSession() {
			questionsArray += oldQuestions
		}
		
		save(questionsArray)
	}
	
	/// Загружает сессию
	func resumeSession() -> [Question]? {
		guard let data = UserDefaults.standard.data(forKey: key) else {
			return nil
		}
		do {
			return try self.decoder.decode([Question].self, from: data)
		} catch {
			print(error)
			return nil
		}
	}
	
	/// Чистит текущую игровую сессию
	func clearSession() {
		UserDefaults.standard.removeObject(forKey: key)
	}
}
