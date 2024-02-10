//
//  FavoriteView.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 10/02/2024.
//

import SwiftUI

struct FavoriteView: View {
    var body: some View {
        ZStack{
            Color.yellow
            
            Image(systemName: "star.fill")
                .foregroundColor(Color.white)
                .font(.system(size: 200.0))
        }
    }
}

#Preview {
    FavoriteView()
}
