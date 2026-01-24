import Foundation

let hwInfo = getHwInfo()

do {
    let data = try hwInfo.serializedData()
    let base64 = data.base64EncodedString()
    print(base64)
} catch {
    fputs("Failed to serialize hardware info: \(error)\n", stderr)
    exit(1)
}
