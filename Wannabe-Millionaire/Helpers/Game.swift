//
//  Game.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 27.01.2022.
//

import Foundation

/// Cинглтон, который хранит данные об игре
final class Game {
	
	/// Порядок вопросов
	enum QuestionsOrder: Int, Codable {
		case successively = 0
		case random
	}
	
	/// Стратегия вывода вопросов
	var order: QuestionsOrder = .successively

	/// Массив рекордов
	private(set) var records: [Record] {
		didSet {
			recordsCaretaker.save(records: self.records)
		}
	}
	
	/// Cервис для сохранения и загрузки рекордов
	private let recordsCaretaker = RecordsCaretaker()
	
	/// Сервис по сохранению игровой сессии
	let sessionCaretaker = GameSessionCaretaker()
	
	static let shared = Game()
	
	private init() {
		records = recordsCaretaker.retrieveRecords()
		sortRecords()
	}
	
	/// Добавить рекорд
	func addRecord(_ record: Record) {
		records.append(record)
		sortRecords()
	}
	
	/// Очистить рекорды
	func clearRecords() {
		self.records = []
	}
	
	/// Сортируем рекорды
	func sortRecords() {
		records = records.sorted(by: {
			$0.score > $1.score
		})
	}
}
