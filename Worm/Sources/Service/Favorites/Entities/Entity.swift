//
//  Entity.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 29.1.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

/// A persisted object.
protocol Entity {

    // MARK: - Properties

    /// The entity name for a Core Data database.
    static var entityName: String { get }

}
