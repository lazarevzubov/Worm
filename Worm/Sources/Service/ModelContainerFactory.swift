//
//  ModelContainerFactory.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 21.7.2026.
//

import Foundation
import SwiftData

/// Creates `ModelContainer`s, recovering from an unreadable on-disk store.
enum ModelContainerFactory {

    // MARK: - Methods

    /// Creates a model container for the given schema and configuration.
    ///
    /// If the store is unreadable (e.g. corrupted), its files are removed and creation is retried once, accepting the
    ///   data loss rather than leaving the caller permanently unable to proceed.
    ///
    /// - Parameters:
    ///   - schema: The schema of the container to create.
    ///   - configuration: The configuration of the container to create.
    /// - Returns: The created model container.
    /// - Throws: Whatever `ModelContainer`'s initializer throws, if creation still fails after the store is reset.
    static func make(for schema: Schema, configuration: ModelConfiguration) throws -> ModelContainer {
        do {
            return try ModelContainer(for: schema, configurations: configuration)
        } catch {
            removeStoreFiles(at: configuration.url)
            return try ModelContainer(for: schema, configurations: configuration)
        }
    }

    // MARK: Private methods

    private static func removeStoreFiles(at url: URL) {
        for suffix in [
            "",
            "-shm",
            "-wal"
        ] {
            try? FileManager.default.removeItem(at: URL(fileURLWithPath: url.path + suffix))
        }
    }

}
