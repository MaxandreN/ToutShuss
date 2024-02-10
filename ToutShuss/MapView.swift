//
//  MapView.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 10/02/2024.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        ZStack{
            Color.green
            
            Image(systemName: "map.circle.fill")
                .foregroundColor(Color.white)
                .font(.system(size: 200.0))
        }
    }
}

#Preview {
    MapView()
}
