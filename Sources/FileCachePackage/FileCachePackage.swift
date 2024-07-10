// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
public final class FileCachePackage<T: JSONParsable> {
    
    public func saveInFile(items: [T], fileName: String) {
        let jsonDataArray = items.map({ $0.json })
        
        //getUrl(from: ) - extension for FileManager
        guard let url = FileManager.default.getUrl(from: fileName) else {
            print("Error getting url")
            return
        }
        //isFileExist(fileName: ) - extension for FileManager
        if FileManager.default.isFileExist(fileName: fileName) {
             print("Error, file existed before")
             return
        }
        let isValidJson = JSONSerialization.isValidJSONObject(jsonDataArray)
        if !isValidJson {
            print("Error, JSON is not valid")
            return
        }
        
        let data: Data
        do {
            data = try JSONSerialization.data(withJSONObject: jsonDataArray, options: [])
        } catch {
            print("Error creating JSON data: \(error.localizedDescription)")
            return
        }
        
        do {
            try data.write(to: url)
            print("File saved: \(url.description)")
        } catch {
            print("Error writing file: \(error.localizedDescription)")
        }
        
    }
    
    //Может быть нужно вернуть nil?
    public func uploadFromFile(fileName: String) -> [T] {
        //getUrl(from: ) - extension for FileManager
        guard let url = FileManager.default.getUrl(from: fileName) else {
            return []
        }
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            print("Error uploading data from file: \(error.localizedDescription)")
            return []
        }
        do {
            let todosJson = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            return todosJson!.compactMap({ T.parse(json: $0) })
        } catch {
            print("Error convert data to JSON: \(error.localizedDescription)")
            return []
        }
    }
}

