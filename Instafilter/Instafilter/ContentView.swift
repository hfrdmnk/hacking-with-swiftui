//
//  ContentView.swift
//  Instafilter
//
//  Created by Dominik Hofer on 24.08.22.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 100.0
    @State private var filterScale = 5.0
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var showingIntensitySlider = false
    @State private var showingRadiusSlider = false
    @State private var showingScaleSlider = false
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var showingFilterSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.secondary)
                        .opacity(0.7)
                    
                    
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                
                GeometryReader { metrics in
                    
                    VStack {
                        
                        if showingIntensitySlider {
                            HStack {
                                Text("Intensity")
                                
                                Spacer()
                                
                                Slider(value: $filterIntensity)
                                    .onChange(of: filterIntensity) { _ in applyProcessing() }
                                    .frame(width: metrics.size.width * 0.6)
                            }
                            .padding(.vertical)
                        }
                        
                        if showingRadiusSlider {
                            HStack {
                                Text("Radius")
                                
                                Spacer()
                                
                                Slider(value: $filterRadius, in: 0...200)
                                    .onChange(of: filterRadius) { _ in applyProcessing() }
                                    .frame(width: metrics.size.width * 0.6)
                            }
                            .padding(.vertical)
                        }
                        
                        if showingScaleSlider {
                            HStack {
                                Text("Intensity")
                                
                                Spacer()
                                
                                Slider(value: $filterScale, in: 0...10)
                                    .onChange(of: filterScale) { _ in applyProcessing() }
                                    .frame(width: metrics.size.width * 0.6)
                            }
                            .padding(.vertical)
                        }
                        
                    }
                
                }
                
                HStack {
                    Button("Change Filter") {
                        showingFilterSheet = true
                    }
                    .buttonStyle(.bordered)
                    .disabled(image == nil)
                    
                    Spacer()
                    
                    Button("Save", action: save)
                    .buttonStyle(.borderedProminent)
                    .disabled(image == nil)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage)  { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Bloom") { setFilter(CIFilter.bloom()) }
                Button("Monochrome") { setFilter(CIFilter.colorMonochrome()) }
                Button("Invert") { setFilter(CIFilter.colorInvert()) }
            }
            .accentColor(.purple)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func save() {
        guard let processedImage = processedImage else { return }

        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Success!")
        }
        
        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        print(inputKeys)
        
        showingScaleSlider = false
        showingRadiusSlider = false
        showingIntensitySlider = false
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
            showingIntensitySlider = true
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius, forKey: kCIInputRadiusKey)
            showingRadiusSlider = true
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale, forKey: kCIInputScaleKey)
            showingScaleSlider = true
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
