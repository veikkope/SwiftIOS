/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that clips an image to a circle and adds a stroke and shadow.
*/

import SwiftUI

struct PartyImage: View {
    var party: String

    var body: some View {
        Image(party) // Load image directly from Assets.xcassets
            .resizable()
            .scaledToFit()
            .frame(width: 35, height: 35) // Adjust size as needed
             
    }
}

