//
//  GameSessionCaretaker.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 28.01.2022.
//

import Foundation

/// Сaretaker класса GameSession, сохраняет и загружает прогресс в игре
final class GameSessionCaretaker {
	
	private let encoder = JSONEncoder()
	private let decoder = JSONDecoder()
	
	private let key = "gameSession"
	
	/// Сохраняет сессию
	func save(_ session: GameSession) {
		do {
			let data = try self.encoder.encode(session)
			UserDefaults.standard.set(data, forKey: key)
		} catch {
			print(error)
		}
	}
	
	/// Загружает сессию
	func resumeSession() -> GameSession? {
		guard let data = UserDefaults.standard.data(forKey: key) else {
			return nil
		}
		do {
			let session = try self.decoder.decode(GameSession.self, from: data)
			session.resume()
			return session
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
