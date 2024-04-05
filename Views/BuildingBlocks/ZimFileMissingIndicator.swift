/*
 * This file is part of Kiwix for iOS & macOS.
 *
 * Kiwix is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * any later version.
 *
 * Kiwix is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Kiwix; If not, see https://www.gnu.org/licenses/.
*/

//
//  ZimFileMissingIndicator.swift
//  Kiwix
//
//  Created by Chris Li on 7/17/22.
//  Copyright © 2022 Chris Li. All rights reserved.
//

import SwiftUI

struct ZimFileMissingIndicator: View {
    var body: some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .renderingMode(.original)
            .help("zim_file_missing_indicator.help".localized)
    }
}
