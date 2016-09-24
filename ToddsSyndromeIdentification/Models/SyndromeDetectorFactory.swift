//
//  SyndromeDetectorFactory.swift
//  ToddsSyndromeIdentification
//
//  Created by Marina Butovich on 9/23/16.
//  Copyright © 2016 Marina Butovich. All rights reserved.
//

import Foundation

public func makeSyndromeDetector(syndrome: SyndromeType) -> SyndromeDetector {
    switch syndrome {
    case .toddsSyndrome:
        return ToddsSyndromeDetector()
    }
}
