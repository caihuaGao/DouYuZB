//
//  CHLiveViewController.swift
//  DYZB
//
//  Created by lx on 2020/11/17.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit
import AVFoundation

class CHLiveViewController: UIViewController {
    
    fileprivate lazy var videoQueue = DispatchQueue.global()
    fileprivate lazy var audoQueue = DispatchQueue.global()

    
    // 视频捕捉会话
    private  lazy var captureSession = AVCaptureSession()
    
    // 显示层
    private lazy var videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    // 视频输入设备
    private let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: AVCaptureDevice.Position.back)
    
    // 音频输入设备
    private let audioDevice = AVCaptureDevice.default(for: .audio)
    // 将捕获的视频输出到文件中
    private var fileOutput: AVCaptureMovieFileOutput?
    
    
    private var audioOutput:AVCaptureAudioDataOutput? = nil
    private var vidoeOutput:AVCaptureVideoDataOutput? = nil
    private var audioInput :AVCaptureDeviceInput?
    private var vidoeInput :AVCaptureDeviceInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        stopCapture()
    }
    

    
    
}

// MARK:- 开始/结束采集/切换摄像头
extension CHLiveViewController {
    
    @IBAction func startCapture(_ sender: Any) {
       
        // 0. 添加之前先清除一遍
//        stopCapture()
        
        // 1. 设置视频的输入和输出
        setupVideo()
        
        // 2. 设置音频的输入和输出
        setupAudo()
        
        // 3添加写入文件Output
        let outFile = AVCaptureMovieFileOutput()
        self.fileOutput = outFile
        if captureSession.canAddOutput(outFile) {
            captureSession.addOutput(outFile)
            // 3.1 设置写入的稳定性
            let connection = outFile.connection(with: AVMediaType.video)
            connection?.preferredVideoStabilizationMode = .auto
        }


        // 4. 使用AVCaptureVideoPreviewLayer可以将摄像头捕获的画面显示
        videoLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(videoLayer, at: 0)
        
        // 5. 启动捕捉会话开始采集
        captureSession.startRunning()

        // 6. 开始讲采集到的画面写入文件中
//        let path = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first! + "lp.mp4"
        let path = "/Users/lx/Desktop/test/lz.mp4"
        let url = URL(fileURLWithPath: path)
        self.fileOutput?.startRecording(to: url, recordingDelegate: self)

        
    }
    @IBAction func endCapture(_ sender: Any) {
        
        stopCapture()
        videoLayer.removeFromSuperlayer()
        
    }
    @IBAction func swichCapture(_ sender: Any) {
        // 1.获取之前的摄像头
        guard var position = vidoeInput?.device.position else {return}
        // 2.获取当前应该显示的摄像头
        position = position == .front ? .back : .front
        // 3.根据当前镜头创建新的device
        guard let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: .video, position: position) else {return}
        // 4.根据新的device创建新的Input
        guard let vidoeInput = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        // 5. 在session中切换Input
        captureSession.beginConfiguration()
        captureSession.removeInput(self.vidoeInput!)
        captureSession.addInput(vidoeInput)
        captureSession.commitConfiguration()
        self.vidoeInput = vidoeInput
        
        
    }
    
}

extension CHLiveViewController {
    
    // MARK:- 设置视频
    func setupVideo(){
        // 添加视频输入设备
        guard let videoDevice = videoDevice  else {
            print("摄像头无法使用")
            return
        }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {return}
        self.vidoeInput = videoInput
        if captureSession.canAddInput(videoInput)  {
            captureSession.addInput(videoInput)
        }
        
        
        // 3. 添加视频捕获输出
        let vidoeOutput = AVCaptureVideoDataOutput()
        vidoeOutput.setSampleBufferDelegate(self, queue: videoQueue)
        if captureSession.canAddOutput(vidoeOutput) {
            captureSession.addOutput(vidoeOutput)
        }
        self.vidoeOutput = vidoeOutput

    }
    
    // MARK:- 设置音频
    func setupAudo() {
        // 添加音频输入设备
        guard let audioDevice = audioDevice else {
            print("录音无法使用")
            return
        }
        guard let audioInput = try? AVCaptureDeviceInput(device: audioDevice) else {return}
        self.audioInput = audioInput
        if captureSession.canAddInput(audioInput) {
            captureSession.addInput(audioInput)
        }
        
        
        let audoOutput = AVCaptureAudioDataOutput()
        audoOutput.setSampleBufferDelegate(self, queue: audoQueue)
        if captureSession.canAddOutput(audoOutput) {
            captureSession.addOutput(audoOutput)
        }
        self.audioOutput = audoOutput
        
    }
    
    // MARK:- 停止录制
    func stopCapture() {
            for input in captureSession.inputs {
                captureSession.removeInput(input)
            }
            
            for output in captureSession.outputs {
                captureSession.removeOutput(output)
            }
        
            fileOutput?.stopRecording()
            captureSession.stopRunning()
    }
    
}

// MARK:- AVCaptureAudioDataOutputSampleBufferDelegate
extension CHLiveViewController : AVCaptureVideoDataOutputSampleBufferDelegate ,AVCaptureAudioDataOutputSampleBufferDelegate{
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
     
        if output == self.audioOutput {
            print("音频采集成功")

        } else if output == self.vidoeOutput {
            print("视频采集成功-------")

        }
        
        
    }
    
    
}

// MARK:- AVCaptureFileOutputRecordingDelegate
extension CHLiveViewController : AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("开始写入数据")
    }
        
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("完成写入数据")
        print(outputFileURL.absoluteString)

    }
    
}
