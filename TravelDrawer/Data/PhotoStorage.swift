import UIKit

/// Saves picked photos as JPEGs under Documents/Photos. `Place.photos` stores
/// just the filenames so SwiftData rows stay small.
enum PhotoStorage {
    private static var directory: URL = {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Photos", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }()

    static func save(_ data: Data) -> String? {
        let filename = "\(UUID().uuidString).jpg"
        let url = directory.appendingPathComponent(filename)
        do {
            try data.write(to: url)
            return filename
        } catch {
            return nil
        }
    }

    static func loadImage(filename: String) -> UIImage? {
        UIImage(contentsOfFile: directory.appendingPathComponent(filename).path)
    }

    static func delete(filename: String) {
        try? FileManager.default.removeItem(at: directory.appendingPathComponent(filename))
    }
}
