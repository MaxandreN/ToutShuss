//
//  StationCardView.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 11/02/2024.
//

import SwiftUI

struct StationCardView: View {
    @EnvironmentObject var bookStations: BookStations
    @EnvironmentObject var clientLocation: Location
    
    var station: Station
    @State var travelTime: Int = 0
    @State var travelDistance: Int = 0
    @State var sheetSize: CGFloat = 0.6
    @State var isShowingDetail = false
    
    init(station: Station) {
        self.station = station
    }
    
    mutating func setTravel (travelTime: Int){
        self.station.travelTime = travelTime
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: (station.galerie.cover)))
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
                    bookStations.toggleFavorite(station: station)
                    //set favorit
                }) {
                    Image(systemName: station.isFavorite ? "star.fill" : "star")
                        .foregroundColor(station.isFavorite ? .yellow : .gray)
                        .padding(.trailing)
                }
                StationTopicView(text: "\(travelDistance)km", condition: travelDistance > 0, color: Color.yellow)
                    .padding(.trailing)
            }
            HStack{
                if(station.minAltitude != -1 && station.maxAltitude != -1)
                {
                    Text("\(station.minAltitude)m - \(station.maxAltitude)m")
                }else if(station.maxAltitude != -1){
                    Text("\(station.maxAltitude)m")
                }else if(station.minAltitude != -1){
                    Text("\(station.minAltitude)m")
                }
                StationTopicView(text: "\(secondsToHoursMinutesSeconds(travelTime))", condition: travelTime > 0, color: Color.yellow)
            }
            .padding(.bottom)
            .onAppear {
                station.getTravelTime(clientLocation: clientLocation) { travelTime, travelDistance in
                    self.travelTime = travelTime
                    self.travelDistance = travelDistance
                }
            }
            
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .onTapGesture {
            isShowingDetail.toggle()
        }
        .sheet(isPresented: $isShowingDetail) {
            StationModaleView(station: station,travelTime: travelTime, travelDistance: travelDistance, sheetSize: $sheetSize
            )
            .presentationDetents([.fraction(sheetSize), .large])
            .animation(.easeIn, value: sheetSize)
        }.environmentObject(clientLocation)
    }
    
}

struct StationTopicView: View {
    var text: String
    var condition: Bool
    var color: Color
    var fontColor : Color = Color.black
    var fontWeight : Font.Weight = .regular
    
    var body: some View{
        if condition {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(color)
                    .frame(width: getTextWidth(text: text) + 30, height: 30)
                Text("\(text)")
                    .foregroundStyle(fontColor)
                    .fontWeight(fontWeight)
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
