//
//  NLogger.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation
import OSLog

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

class NLogger {
    static let shared = NLogger()
    
    // Current log level - adjust this to control verbosity
    var currentLogLevel: LogLevel = .debug
    
    // Method to log a message
    func log(_ message: String, level: LogLevel = .debug, file: String = #file, function: String = #function, line: Int = #line) {
        guard shouldLog(level) else { return }
        
        let fileName = (file as NSString).lastPathComponent
        let timestamp = getCurrentTimestamp()
        let logger = Logger(
            subsystem: "\(fileName)-\(line)",
            category: function
        )
        let p1 = "\(timestamp) [\(level.rawValue)]"
        let p2 = String(repeating: "-", count: p1.count)
        logMessage("\(p1)\n\(p2)\n\(message)", level: level, logger: logger)
    }
    
    // Helper method to determine if a message should be logged
    private func shouldLog(_ level: LogLevel) -> Bool {
        switch (currentLogLevel, level) {
        case (.debug, _), (.info, .info), (.info, .warning), (.info, .error),
            (.warning, .warning), (.warning, .error), (.error, .error):
            return true
        default:
            return false
        }
    }
    
    // Method to get the current timestamp
    private func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    private func logMessage(_ message: String, level: LogLevel, logger: Logger) {
        switch level {
        case .debug:
            logger.log("\(message)")
        case .info:
            logger.info("\(message)")
        case .warning:
            logger.warning("\(message)")
        case .error:
            logger.critical("\(message)")
        }
    }
}
