//
//  Caretaker.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 02.02.2022.
//

import Foundation

/// Сaretaker класса GameSession, сохраняет и загружает прогресс в игре
final class Caretaker {
	
	private let encoder = JSONEncoder()
	private let decoder = JSONDecoder()
	
	private let key: String
	
	init(key: String) {
		self.key = key
	}
	
	/// Сохраняет сессию
	func save<T: Codable>(_ questions: T) {
		do {
			let data = try self.encoder.encode(questions)
			UserDefaults.standard.set(data, forKey: key)
		} catch {
			print(error)
		}
	}
	
	/// Загружает сессию
	func resumeSession<T: Codable>() -> T? {
		guard let data = UserDefaults.standard.data(forKey: key) else {
			return nil
		}
		do {
			return try self.decoder.decode(T.self, from: data)
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
