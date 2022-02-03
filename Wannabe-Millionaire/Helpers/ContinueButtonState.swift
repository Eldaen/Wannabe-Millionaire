//
//  ContinueButtonState.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 03.02.2022.
//

/// Состояния кнопки ПРОДОЛЖИТЬ
enum ContinueButtonState {
	case on
	case off
	
	var bool: Bool {
		switch self {
		case .off:
			return true
		default:
			return false
		}
	}
}
