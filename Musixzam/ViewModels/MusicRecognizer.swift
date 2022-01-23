//
//  MusicRecognizer.swift
//  Musixzam
//
//  Created by NAVEEN MADHAN on 1/19/22.
//

import Foundation
import SwiftUI
import ShazamKit
import AVKit

class ShazamRecognizer: NSObject,ObservableObject,SHSessionDelegate {
    
    @Published var session = SHSession()
    
    
    @Published var audioEngine = AVAudioEngine()
    
    @Published var errorMsg = ""
    @Published var showError = false
    
    @Published var isRecording = false
    
    @Published var matchedTrack: Track!
    
    override init() {
        super.init()
        session.delegate = self
    }
    
    func session(_ session: SHSession, didFind match: SHMatch) {
        
        if let firstItem = match.mediaItems.first{
            
            DispatchQueue.main.async {
                
                self.matchedTrack = Track(
                    title: firstItem.title ?? "",
                    artist: firstItem.artist ?? "",
                    artwork: firstItem.artworkURL ?? URL(string: "")!,
                    genres: firstItem.genres,
                    appleMusicURL: firstItem.appleMusicURL ?? URL(string: "")!
                )
                
                self.stopRecording()
            }
        }
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        
        DispatchQueue.main.async {
            self.errorMsg = error?.localizedDescription ?? "No Music Found....."
            self.showError.toggle()
            self.stopRecording()
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        withAnimation{
            isRecording = false
        }
    }
    
    
    func listnenMusic() {
        
        let audioSession = AVAudioSession.sharedInstance()
        
        audioSession.requestRecordPermission { status in
            if status {
                self.recordAudio()
            } else {
                self.errorMsg = "Please Allow Microphone Access !!!"
                self.showError.toggle()
            }
        }
    }
    
    func recordAudio() {
        
        if audioEngine.isRunning{
            self.stopRecording()
            return
        }
        
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: .zero)
        
        inputNode.removeTap(onBus: .zero)
        inputNode.installTap(onBus: .zero, bufferSize: 1024, format: format) { buffer, time in
            self.session.matchStreamingBuffer(buffer, at: time)
        }
        
        audioEngine.prepare()
        
        do{
            try audioEngine.start()
            print("Started")
            withAnimation{
                self.isRecording = true
            }
        }
        catch{
            self.errorMsg = error.localizedDescription
            self.showError.toggle()
        }
    }
}
