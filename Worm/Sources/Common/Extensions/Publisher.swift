//
//  Publisher.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 17.2.2025.
//  Copyright © 2025 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine

// MARK: - Sendable

extension Published.Publisher: @unchecked @retroactive Sendable { }
