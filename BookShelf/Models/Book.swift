//
//  Book.swift
//  BookShelf
//
//  Created by Daniel José Villamizar on 29/12/22.
//

import Foundation
import RealmSwift

class Books: Codable {
    let items: [Book]
}

struct Book: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String?
    let subtitle: String?
    let imageLinks: ImageLink?
    let pageCount: Int?
    let publishedDate: String?
    let authors: [String]?
    let previewLink: String?
}

struct ImageLink: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
    let small: String?
    let medium: String?
    let large: String?
    let extraLarge: String?
}

class BookRealm: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var volumeInfo: VolumeInfoRealm?
    
    convenience init(id: String, volumeInfo: VolumeInfoRealm) {
        self.init()
        self.id = id
        self.volumeInfo = volumeInfo
    }
}

class VolumeInfoRealm: Object {
    @Persisted var title: String?
    @Persisted var subtitle: String?
    @Persisted var imageLinks: ImageLinkRealm?
    @Persisted var pageCount: Int?
    @Persisted var publishedDate: String?
    @Persisted var authors: List<String>
    @Persisted var previewLink: String?
    
    convenience init(title: String?, subtitle: String?, imageLinks: ImageLinkRealm, pageCount: Int?, publishedDate: String?,
//                     authors: List<String?>,
                     previewLink: String?) {
        self.init()
        self.title = title
        self.subtitle = subtitle
        self.imageLinks = imageLinks
        self.pageCount = pageCount
        self.publishedDate = publishedDate
//        self.authors = authors.map({ nullable in
//            return nullable ?? ""
//        })
        self.previewLink = previewLink
    }
}

class ImageLinkRealm: Object {
    @Persisted var smallThumbnail: String?
    @Persisted var thumbnail: String?
    @Persisted var small: String?
    @Persisted var medium: String?
    @Persisted var large: String?
    @Persisted var extraLarge: String?
    
    convenience init(smallThumbnail: String?, thumbnail: String?, small: String?, medium: String?, large: String?, extraLarge: String?) {
        
        self.init()
        self.smallThumbnail = smallThumbnail
        self.thumbnail = thumbnail
        self.small = small
        self.medium = medium
        self.large = large
    }
}

func convertToRealmObject(book: Book) -> BookRealm {
    
    let imageLink = book.volumeInfo.imageLinks
    let imageLinkRealm = ImageLinkRealm(smallThumbnail: imageLink?.smallThumbnail, thumbnail: imageLink?.thumbnail, small: imageLink?.small, medium: imageLink?.medium, large: imageLink?.large, extraLarge: imageLink?.extraLarge)
    
    let volumeInfo = book.volumeInfo
    let volumeInfoRealm = VolumeInfoRealm(title: volumeInfo.title, subtitle: volumeInfo.subtitle, imageLinks: imageLinkRealm, pageCount: volumeInfo.pageCount, publishedDate: volumeInfo.publishedDate,
//                                          authors: volumeInfo.authors,
                                          previewLink: volumeInfo.previewLink)
    
    let bookRealm = BookRealm(id: book.id, volumeInfo: volumeInfoRealm)
    
    return bookRealm
}


