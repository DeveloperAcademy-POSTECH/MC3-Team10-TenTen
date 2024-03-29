//
//  ImageManager.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/27.
// swiftlint:disable force_try

import Foundation
import UIKit

// TODO: Refactor
// TODO: File Directory가 Pet과 Letter가 다르도록 configuration할 수 있는 singleton 구조 만들기
class ImageManager {
    public static var shared: ImageManager? = ImageManager()
    
    private static let ENDPOINT = "image"
    private let fileManager: FileManager
    private let documentPath: URL
    public var imagePath: URL {
        return self.documentPath.appendingPathComponent(ImageManager.ENDPOINT)
    }
    
    public func fileNameGenerator(_ imageType: ImageType = .png) -> String {
        let ymd = DateConverter.dateToString(Date.now, .yearMonthDateHyphen)
        return ymd + UUID().uuidString + imageType.value
    }
    
    public func saveImage(_ image: UIImage) throws -> String {
        guard let pngImage = image.pngData() else {
            throw RealmError.petNotFound
        }
        let fileName: String = fileNameGenerator(.png)
        let imageUrl: URL = imagePath.appendingPathComponent(fileName)
        do {
            try pngImage.write(to: imageUrl)
        } catch {
            throw ImageManagerError.imageWriteError
        }
        return fileName
    }
    
    public func createDirectory() throws {
        let filePath = imagePath
        if !fileManager.fileExists(atPath: filePath.path) {
            do {
                try fileManager.createDirectory(
                    atPath: filePath.path,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch {
                throw ImageManagerError.directoryCreateError
            }
        }
    }
    
    public func deleteFile(_ fileUrl: URL) throws {
        if fileManager.fileExists(atPath: fileUrl.path) {
            do {
                try fileManager.removeItem(at: fileUrl)
            } catch {
                throw ImageManagerError.fileDeletionError
            }
        }
    }
    
    private init?() {
        fileManager = FileManager.default
        guard let path = try? fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ) else {
            return nil
        }
        documentPath = path
        try! createDirectory()
    }
}
