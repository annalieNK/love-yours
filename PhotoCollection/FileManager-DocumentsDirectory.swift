//
//  FileManager-DocumentsDirectory.swift
//  PhotoCollection
//
//  Created by Annalie Kruseman on 8/10/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)//.first!
        return paths[0]
    }
}
