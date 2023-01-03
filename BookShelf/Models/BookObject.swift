//
//  BookObject.swift
//  BookShelf
//
//  Created by Daniel José Villamizar on 3/01/23.
//

import Foundation
import RealmSwift

class BooksObject: Object, Decodable {
    @Persisted var items = List<BookObject>()
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decode(List<BookObject>.self, forKey: .items)
        
    }
}

class BookObject: Object, Decodable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var volumeInfo: VolumeInfoObject?
    
    enum CodingKeys: String, CodingKey {
        case id
        case volumeInfo
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.volumeInfo = try container.decode(VolumeInfoObject.self, forKey: .volumeInfo)
    }
}

class VolumeInfoObject: Object, Decodable {
    @Persisted var title: String?
    @Persisted var subtitle: String?
    @Persisted var imageLinks: ImageLinksObject?
    @Persisted var pageCount: Int?
    @Persisted var publishedDate: String?
    @Persisted var authors: List<String>
    @Persisted var previewLink: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case imageLinks
        case pageCount
        case publishedDate
        case authors
        case previewLink
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        self.imageLinks = try container.decodeIfPresent(ImageLinksObject.self, forKey: .imageLinks)
        self.pageCount = try container.decodeIfPresent(Int.self, forKey: .pageCount)
        self.publishedDate = try container.decodeIfPresent(String.self, forKey: .publishedDate)
        self.authors = try container.decodeIfPresent(List<String>.self, forKey: .authors) ?? List<String>()
        self.previewLink = try container.decodeIfPresent(String.self, forKey: .previewLink)
    }
}


class ImageLinksObject: Object, Decodable {
    @Persisted var smallThumbnail: String?
    @Persisted var thumbnail: String?
    @Persisted var small: String?
    @Persisted var medium: String?
    @Persisted var large: String?
    @Persisted var extraLarge: String?
    
    enum CodingKeys: String, CodingKey {
        case smallThumbnail
        case thumbnail
        case small
        case medium
        case large
        case extraLarge
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.smallThumbnail = try container.decodeIfPresent(String.self, forKey: .smallThumbnail)
        self.thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        self.small = try container.decodeIfPresent(String.self, forKey: .small)
        self.medium = try container.decodeIfPresent(String.self, forKey: .medium)
        self.large = try container.decodeIfPresent(String.self, forKey: .large)
    }
}
