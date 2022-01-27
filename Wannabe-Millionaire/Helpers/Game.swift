//
//  Game.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 27.01.2022.
//

import Foundation

/// Cинглтон, который хранит данные об игре
final class Game {
	
	static let shared = Game()
	
	/// Массив рекордов
	private(set) var records: [Record] = []
	
	private init() { }
	
	/// Добавить рекорд
	func addRecord(_ record: Record) {
		self.records.append(record)
	}
	
	/// Очистить рекорды
	func clearRecords() {
		self.records = []
	}
}
