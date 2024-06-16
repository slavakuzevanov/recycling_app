//
//  ViewControllerCamera.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 16.06.2024.
//

import UIKit
import AVFoundation
import Vision
import SwiftUI

class ViewControllerCamera: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak private var previewView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    
    var bufferSize: CGSize = .zero
    var rootLayer: CALayer! = nil // Set up empty layer
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    }
    
    
    override func viewDidLoad() {
        UIApplication.shared.isIdleTimerDisabled = true // Prevent the device from going to sleep
        super.viewDidLoad()
        
        // Launch camera only if device is connected to allow for tests without device
        if (TARGET_IPHONE_SIMULATOR == 0) {
                setupAVCapture() // Preview stuff
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setupAVCapture() {
        print("SetupAVCapture started")
        var deviceInput: AVCaptureDeviceInput!
        
        // Select a video device, make an input
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first // TODO: use back camera
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        // Begins list of configurations. They are applied after commitConfiguration.
        session.beginConfiguration()
        
        // Add a video input
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        session.addInput(deviceInput)
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            // Add a video data output
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        }
        else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        let captureConnection = videoDataOutput.connection(with: .video)
                
        // Always process the frames
        captureConnection?.isEnabled = true
        do {
            try  videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            
            // Swap height and width because of input video orientation
            bufferSize.width = CGFloat(dimensions.height)
            bufferSize.height = CGFloat(dimensions.width)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        
        // Apply the configurations
        session.commitConfiguration()
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // Fill screen
        
        rootLayer = previewView.layer // Assign the previewView’s layer to rootLayer
        previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)
        previewView.addSubview(captureButton)
    }
    
    
    func startCaptureSession() {
        session.startRunning()
    }
    
    
    // Clean up capture setup
    func teardownAVCapture() {
        previewLayer.removeFromSuperlayer()
        previewLayer = nil
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didDrop didDropSampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    }
    
    @IBAction func didTapCaptureButton(_ sender: Any) {
        print("Capture Button Tapped")
    }
}
