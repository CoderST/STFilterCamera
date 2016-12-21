//
//  STCameraView.swift
//  STFilterCamera
//
//  Created by xiudou on 2016/12/20.
//  Copyright © 2016年 CoderST. All rights reserved.
//

import UIKit
import GPUImage
class STCameraView: UIView {
    
    
    /// 磨皮
    let bilateralFilter = GPUImageBilateralFilter()
    /// 曝光
    let exposureFilter = GPUImageExposureFilter()
    /// 美白
    let brightnessFilter = GPUImageBrightnessFilter()
    /// 饱和
    let satureationFilter = GPUImageSaturationFilter()
    
    /// 预览图层
    private lazy var preview = GPUImageView()
    /// 相机(默认前置摄像头)
    private lazy var camera : GPUImageVideoCamera? = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: .Front)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        preview.frame = bounds
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- 对外暴露的函数
extension STCameraView {
    // 旋转摄像头方向
    func rotateCamera() {
        
        camera?.rotateCamera()
    }
    
    // 开始美颜
    func startBeautiful() {
        camera?.removeAllTargets()
        let group = getGroupFilters()
        camera?.addTarget(group)
        group.addTarget(preview)
    }
    
    // 去除美颜
    func removeBeautiful() {
        camera?.removeAllTargets()
        camera?.addTarget(preview)
    }
    
    // 设置磨皮
    func changebilateralFilter(value : CGFloat){
        bilateralFilter.distanceNormalizationFactor = value * 8
    }
    // 设置曝光
    func changeexposureFilter(value : CGFloat){
        // - 10 ~ 10
        exposureFilter.exposure = value * 20 - 10
    }
    // 设置美白
    func changebrightnessFilter(value : CGFloat){
        // - 1 --> 1
        brightnessFilter.brightness = value * 2 - 1
        
    }
    // 设置饱和
    func change(value : CGFloat){
        satureationFilter.saturation = value * 2
    }
    
}

/// 基本配置
extension STCameraView {
    
    private func setupUI() {
        // 1.设置camera方向
        camera?.outputImageOrientation = .Portrait
        camera?.horizontallyMirrorFrontFacingCamera = true
        
        // 2.创建预览的View
        insertSubview(preview, atIndex: 0)
        
        // 3.获取滤镜组
        let filterGroup = getGroupFilters()
        
        // 4.设置GPUImage的响应链
        camera?.addTarget(filterGroup)
        filterGroup.addTarget(preview)
        
        // 5.开始采集视频
        camera?.startCameraCapture()
        
    }
    
    private func getGroupFilters() -> GPUImageFilterGroup {
        // 1.创建滤镜组（用于存放各种滤镜：美白、磨皮等等）
        let filterGroup = GPUImageFilterGroup()
        
        // 2.创建滤镜(设置滤镜的引来关系)
        bilateralFilter.addTarget(brightnessFilter)
        brightnessFilter.addTarget(exposureFilter)
        exposureFilter.addTarget(satureationFilter)
        
        // 3.设置滤镜组链初始&终点的filter
        filterGroup.initialFilters = [bilateralFilter]
        filterGroup.terminalFilter = satureationFilter
        
        return filterGroup
    }
    
    
}
