//
//  HapticsManager.swift
//  MySpotify
//
//  Created by Alexander Germek on 15.05.2021.
//

import UIKit

final class HapticsManager {

	static let shared = HapticsManager()
	
	public func vibrateForSelection() {
		DispatchQueue.main.async {
			let generator = UISelectionFeedbackGenerator()
			generator.prepare()
			generator.selectionChanged()
		}
	}

	public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {

		DispatchQueue.main.async {
			let generator = UINotificationFeedbackGenerator()
			generator.prepare()
			generator.notificationOccurred(type)
		}
	}
}
