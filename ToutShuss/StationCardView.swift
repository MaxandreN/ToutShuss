//
//  StationCardView.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 11/02/2024.
//

import SwiftUI

struct StationCardView: View {
    var station: Station
    @State var thisClientLocation: Location = clientLocation
    @State var travelTime: Int = 0
    @State var travelDistance: Int = 0
    let onFavoriteToggle: () -> Void
    @State var isShowingDetail = false
    
    init(station: Station, onFavoriteToggle: @escaping () -> Void) {
        self.onFavoriteToggle = onFavoriteToggle
        self.station = station
        
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://img.freepik.com/photos-gratuite/portrait-belle-chaine-montagnes-recouverte-neige-sous-ciel-nuageux_181624-4974.jpg"))
            { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } placeholder: {
                ProgressView()
            }.frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            HStack {
                Text(station.name)
                    .font(.title)
                    .padding(.leading, 10)
                Spacer()
                
                Button(action: {
                    onFavoriteToggle()
                }) {
                    Image(systemName: station.isFavorite ? "star.fill" : "star")
                        .foregroundColor(station.isFavorite ? .yellow : .gray)
                        .padding(.trailing)
                }
                StationTopicView(text: "\(travelDistance)km", condition: travelDistance > 0)
                    .padding(.trailing)
            }
            HStack{
                if(station.minAltitude != nil && station.maxAltitude != nil)
                {
                    Text("\(station.minAltitude ?? 0)m - \(station.maxAltitude ?? 0)m")
                }else if(station.maxAltitude != nil){
                    Text("\(station.maxAltitude ?? 0)m")
                }else if(station.minAltitude != nil){
                    Text("\(station.minAltitude ?? 0)m")
                }
                StationTopicView(text: "\(secondsToHoursMinutesSeconds(travelTime))", condition: travelTime > 0)
            }
            .padding(.bottom)
            .onAppear {
                station.getTravelTime(clientCoordinate: self.thisClientLocation.location) { travelTime, travelDistance in
                    self.travelTime = travelTime
                    self.travelDistance = travelDistance
                }
            }
            
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct StationTopicView: View {
    var text: String
    var condition: Bool
    
    var body: some View{
        if condition {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.yellow)
                    .frame(width: getTextWidth(text: text) + 30, height: 30)
                Text("\(text)")
            }
        }
    }
    
    func getTextWidth(text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: fontAttributes)
        return size.width
    }
}

func secondsToHoursMinutesSeconds(_ time: Int) -> (String) {
    if(time < 1){
        return ""
    }
    let h: Int = (time / 60)
    let m: Int = (time % 60) % 60
    let zero: String = m < 10 ? "0" : ""
    if h < 1 {
        return ("\(zero)\(m)min")
    }else{
        return ("\(h)h\(zero)\(m)")
    }
}


#Preview {
    ContentView()
}