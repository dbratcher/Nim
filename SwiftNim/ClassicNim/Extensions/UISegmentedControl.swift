//
//  UISegmentControl.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/24/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    /// Checks the currently selected segment and returns it's title if present
    ///
    /// - Returns: The title string of the selected segment if present
    var selectedTitle: String? {
        if selectedSegmentIndex < 0 || selectedSegmentIndex > numberOfSegments {
            assert(false, "Invalid segment number returned.")
            return nil
        }

        guard let title = titleForSegment(at: selectedSegmentIndex) else {
            assert(false, "Segment without title selected.")
            return nil
        }

        return title
    }

    /// Returns the index for the segment with the given title if one exists
    ///
    /// - Parameter title: The title of the segment to return the index for
    /// - Returns: The index of the segment with the given title or nil if not present
    func index(for title: String) -> Int? {
        for index in 0..<numberOfSegments {
            if titleForSegment(at: index) == title {
                return index
            }
        }

        return nil
    }

    /// Select a segment for a given title
    ///
    /// - Parameter title: The title of the segment to select
    func selectSegment(titled title: String) {
        if let targetIndex = index(for: title) {
            selectedSegmentIndex = targetIndex
        } else {
            assert(false, "Unable to select index with title: \(title)")
        }
    }
}
