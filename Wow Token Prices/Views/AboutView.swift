//
//  AboutView.swift
//  Wow Token Prices
//
//  Created by Daniel Reszyński on 06/04/2021.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("""
            WoWTokenPrices iOS app is developed using data feed available at wowtokenprices.com
            WoWTokenPrices.com Data Feed is released under the Open Data Commons Attribution License.
            """)
                .font(.callout)
                .padding()
            Spacer()
            Spacer()
            Text("""
            ©1996 - 2014 Blizzard Entertainment, Inc. All rights reserved. Battle.net and Blizzard Entertainment are trademarks or registered trademarks of Blizzard Entertainment, Inc. in the U.S. and/or other countries.

            ©2004 Blizzard Entertainment, Inc. All rights reserved. World of Warcraft, Warcraft and Blizzard Entertainment are trademarks or registered trademarks of Blizzard Entertainment, Inc. in the U.S. and/or other countries.
            """)
                .font(.footnote)
                .foregroundColor(Color.secondary)
        }
        .padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
