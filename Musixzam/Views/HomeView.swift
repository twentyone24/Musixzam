//
//  HomeView.swift
//  Musixzam
//
//  Created by NAVEEN MADHAN on 1/19/22.
//

import SwiftUI

struct HomeView: View {
    
    
    @StateObject var shazamSession = ShazamRecognizer()
    
    var body: some View {
        
        ZStack{
            
            NavigationView{
                
                VStack{
                    
                    
                    Button {
                        shazamSession.listnenMusic()
                    } label: {
                        
                        Image(systemName: shazamSession.isRecording ? "stop" : "mic")
                            .font(.system(size: 35).bold())
                            .symbolVariant(.fill)
                            .padding(30)
                            .background(Color.cyan,in: Circle())
                            .foregroundStyle(.white)
                    }
                    
                }
                .navigationTitle("Shazam Kit")
            }
            
            if let track = shazamSession.matchedTrack{
                
                ZStack{
                    
                    AsyncImage(url: track.artwork) { phase in
                        
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Color.white
                        }
                    }
                    .overlay(.ultraThinMaterial)
                    .frame(width: UIScreen.main.bounds.width)
                    

                    VStack(spacing: 15) {
                        
                        AsyncImage(url: track.artwork) { phase in
                            
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width - 100,height: 300)
                                    .cornerRadius(12)
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 100,height: 300)
                        
                        Text(track.title)
                            .font(.title2.bold())
                            .padding(.horizontal)
                        
                        Text("Artist: **\(track.artist)**")
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text("Genres")
                                .padding(.leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack(spacing: 10){
                                    
                                    ForEach(track.genres,id: \.self){genre in
                                        
                                        Button {
                                            
                                        } label: {
                                            Text(genre)
                                                .font(.caption)
                                        }
                                        .buttonStyle(.bordered)
                                        .controlSize(.small)
                                        .buttonStyle(.borderedProminent)
                                        .tint(Color.black)
                                        
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        
                        Link(destination: track.appleMusicURL) {
                            Text("Play in Apple Music")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .tint(Color.blue)
                        .padding(5)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(
                        
                        Button(action: {
                            shazamSession.matchedTrack = nil
                            shazamSession.stopRecording()
                        }, label: {
                            
                            Image(systemName: "xmark")
                                .font(.caption)
                                .padding(10)
                                .background(Color.white,in: Circle())
                                .foregroundStyle(.black)
                        })
                            .padding(10)
                        
                        ,alignment: .topTrailing
                        
                    )
                }
            }
        }
        .alert(shazamSession.errorMsg, isPresented: $shazamSession.showError) {
            Button("Close",role: .cancel){
                
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
