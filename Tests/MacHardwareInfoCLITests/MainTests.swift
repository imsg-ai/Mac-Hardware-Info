import XCTest
import Foundation
import SwiftProtobuf

final class MainTests: XCTestCase {
    
    /// Test that the CLI executes successfully and outputs valid base64
    func testCLIOutputsValidBase64() throws {
        let process = Process()
        let pipe = Pipe()
        
        // Get the path to the built executable
        let executableURL = productsDirectory.appendingPathComponent("MacHardwareInfoCLI")
        
        process.executableURL = executableURL
        process.standardOutput = pipe
        process.standardError = FileHandle.nullDevice
        
        try process.run()
        process.waitUntilExit()
        
        XCTAssertEqual(process.terminationStatus, 0, "CLI should exit with status 0")
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        XCTAssertNotNil(output, "CLI should produce output")
        XCTAssertFalse(output!.isEmpty, "CLI output should not be empty")
        
        // Verify output is valid base64
        let decodedData = Data(base64Encoded: output!)
        XCTAssertNotNil(decodedData, "CLI output should be valid base64")
        XCTAssertGreaterThan(decodedData!.count, 0, "Decoded data should not be empty")
        
        // Save output to artifacts directory if running in CI
        if let artifactsDir = ProcessInfo.processInfo.environment["CIRCLE_ARTIFACTS"] {
            let artifactPath = URL(fileURLWithPath: artifactsDir).appendingPathComponent("hwinfo_base64.txt")
            try output!.write(to: artifactPath, atomically: true, encoding: .utf8)
            print("Saved base64 output to: \(artifactPath.path)")
            
            // Decode protobuf and save as plain text
            let hwInfo = try Bbhwinfo_HwInfo(serializedBytes: decodedData!)
            let textFormat = hwInfo.textFormatString()
            let textArtifactPath = URL(fileURLWithPath: artifactsDir).appendingPathComponent("hwinfo_text.txt")
            try textFormat.write(to: textArtifactPath, atomically: true, encoding: .utf8)
            print("Saved text output to: \(textArtifactPath.path)")
        }
    }
    
    /// Returns path to the built products directory.
    var productsDirectory: URL {
        #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
        #else
        return Bundle.main.bundleURL
        #endif
    }
}
