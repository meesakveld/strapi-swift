//
//  MediaFilesQuery.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 06/03/2025.
//

import Foundation
import UIKit

@MainActor
public struct MediaFilesQuery {
    private let baseURLProvider: () throws -> String
    
    init(baseURLProvider: @escaping () throws -> String) {
        self.baseURLProvider = baseURLProvider
    }
    
    /// Gets a list of media files from Strapi
    public func getFiles<T: Decodable>(as type: T.Type) async throws -> T {
        let baseURL = try baseURLProvider()
        let url = URL(string: "\(baseURL)/api/upload/files")!
        
        return try await makeRequest(to: url, as: T.self)
    }
    
    /// Uploads an image to Strapi from a UIImage
    public func uploadImage(image: UIImage) async throws -> StrapiImage? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "MediaFilesQuery", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not convert UIImage to JPEG data"])
        }
        
        let fileName = "image_\(UUID().uuidString).jpg"
        let mimeType = "image/jpeg"
        
        let response = try await uploadImage(data: imageData, fileName: fileName, mimeType: mimeType)
        return response
    }
    
    /// Uploads a file to Strapi from a URL
    public func uploadImage(fileURL: URL) async throws -> StrapiImage? {
        // Fetch image
        let (data, _) = try await URLSession.shared.data(from: fileURL)
        let fileName = fileURL.lastPathComponent
        let mimeType = mimeType(for: fileURL.path)
        
        let response = try await uploadImage(data: data, fileName: fileName, mimeType: mimeType)
        return response
    }
    
    /// Returns a query based on a file's id
    public func withId(_ id: Int) async throws -> MediaFileQuery {
        return MediaFileQuery(id: id, baseURLProvider: self.baseURLProvider)
    }
    
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// General upload function
    private func uploadImage(data: Data, fileName: String, mimeType: String) async throws -> StrapiImage? {
        let baseURL = try baseURLProvider()
        let url = URL(string: "\(baseURL)/api/upload")!
          
        let (body, boundary) = generateFileBody(data: data, fileName: fileName, mimeType: mimeType)
        
        let response = try await makeRequest(
            to: url,
            requestType: .POST,
            contentType: .multipartFormData(boundary: boundary),
            body: body,
            as: [StrapiImage].self
        )
        return response.first
    }
    
    private func generateFileBody(data: Data, fileName: String, mimeType: String) -> (data: Data, boundary: String) {
        let boundary = UUID().uuidString

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return (data: body, boundary: boundary)
    }
    
    private func mimeType(for path: String) -> String {
        let ext = (path as NSString).pathExtension.lowercased()
        switch ext {
        case "jpg", "jpeg": return "image/jpeg"
        case "png": return "image/png"
        case "gif": return "image/gif"
        case "pdf": return "application/pdf"
        default: return "application/octet-stream"
        }
    }
    
}
