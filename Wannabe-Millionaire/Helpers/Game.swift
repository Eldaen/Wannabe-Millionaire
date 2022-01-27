//
//  Game.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 27.01.2022.
//

import Foundation

/// Cинглтон, который хранит данные об игре
final class Game {

	/// Массив рекордов
	private(set) var records: [Record] {
		didSet {
			recordsCaretaker.save(records: self.records)
		}
	}
	
	/// Cервис для сохранения и загрузки рекордов
	private let recordsCaretaker = RecordsCaretaker()
	
	static let shared = Game()
	
	private init() {
		records = recordsCaretaker.retrieveRecords()
	}
	
	/// Добавить рекорд
	func addRecord(_ record: Record) {
		self.records.append(record)
	}
	
	/// Очистить рекорды
	func clearRecords() {
		self.records = []
	}
}
