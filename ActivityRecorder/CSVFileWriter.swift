
import Foundation

class CSVFileWriter {
    
    var fileHandle: FileHandle?
    init(with URL:URL, header: String) {
        if !FileManager.default.fileExists(atPath: URL.path) {
            FileManager.default.createFile(atPath: URL.path, contents: nil, attributes: nil)
        }
        fileHandle = try? FileHandle(forWritingTo: URL)
        guard let headerData = header.data(using: .utf8) else {
            return
        }
        fileHandle?.write(headerData)
    }
    
    func append(_ newString: String) {
        guard let data = newString.data(using: .utf8) else {
            return
        }
        do {
            try fileHandle?.seekToEnd()
            fileHandle?.write(data)
        } catch {
            print("Error: Failed to write the data - \(error)")
        }
    }
    
    func close() {
        do {
            try fileHandle?.close()
        } catch {
            print("Error: Failed to close the file - \(error)")
        }
    }
}
