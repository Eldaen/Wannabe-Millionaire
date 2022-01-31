//
//  RecordsCaretaker.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 27.01.2022.
//

import Foundation

/// Класс для сохранения данных о рекордах в Userdefaults и их загрузке оттуда
final class RecordsCaretaker {
	
	private let encoder = JSONEncoder()
	private let decoder = JSONDecoder()
	
	private let key = "records"
	
	func save(records: [Record]) {
		do {
			let data = try self.encoder.encode(records)
			UserDefaults.standard.set(data, forKey: key)
		} catch {
			print(error)
		}
	}
	
	func retrieveRecords() -> [Record] {
		guard let data = UserDefaults.standard.data(forKey: key) else {
			return []
		}
		do {
			return try self.decoder.decode([Record].self, from: data)
		} catch {
			print(error)
			return []
		}
	}
}
