//
//  Record.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 27.01.2022.
//

import Foundation

struct Record: Codable {
	let date: Date
	let score: Int
	
	/// Возвращаем красивую дату cтрокой из unixtime
	func getDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ru_RU")
		dateFormatter.timeStyle = DateFormatter.Style.short
		dateFormatter.dateStyle = DateFormatter.Style.medium
		dateFormatter.timeZone = .current
		let localDate = dateFormatter.string(from: date)
		return localDate
	}
}
