//
//  Extensions.swift
//  MySpotify
//
//  Created by iMac on 15.05.2021.
//

import UIKit

extension UIView {
    
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }
}


extension DateFormatter {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}


extension String {
    static func formattedDate(string: String) -> String {
        
        guard let date = DateFormatter.dateFormatter.date(from: string) else {
            return string
        }
        
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}


extension Notification.Name {
    static let albumSavedNotification = Notification.Name("albumSavedNotification")
}
