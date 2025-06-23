//
//  DeveloperView.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 21/06/25.
//

import SwiftUI

struct DeveloperView: View {
    @EnvironmentObject var colorManager: ThemeManager
    @ObservedObject var viewModel: HomeViewModel
    @State private var theme: ColorTheme = .light
    
    @State private var primaryColor: Color = .blue
    @State private var fontColot: Color = .gray
    @State private var callToActionColor: Color = .green
    @State private var mainColor: Color = .yellow
    @State private var backgroundColor: Color = .white
    @State private var textColor: Color = .black
    
    var body: some View {
        ViewWrapper(showHeader: false, showBackButton: true, buttonAction: {
            viewModel.goBack()
        }) {
            VStack {
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        Text("Configura tu app")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.black)
                        
                        phone
                        
                        HStack {
                            Text("Selecciona un tema")
                                .fontWeight(.medium)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Picker("Selecciona un tema", selection: $theme) {
                                ForEach(ColorTheme.allCases, id: \.id) { theme in
                                    Text(theme.name).tag(theme)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.horizontal)
                        }
                        .padding()
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        if theme == .custom {
                            VStack {
                                ColorPicker("Color primario", selection: $primaryColor)
                                ColorPicker("Color de texto", selection: $textColor)
                                ColorPicker("Color de fuente (body)", selection: $fontColot)
                                ColorPicker("Color call to action", selection: $callToActionColor)
                                ColorPicker("Color Main", selection: $mainColor)
                                ColorPicker("Color de fondo", selection: $backgroundColor)
                            }
                            .padding()
                            .foregroundStyle(.black)
                            .background(.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                        }
                        
                        Spacer()
                    }
                }
                .onChange(of: theme) { oldValue, newValue in
                    if newValue == .custom {
                        let palette = ColorPalette(
                            primaryColor: primaryColor,
                            fontColot: fontColot,
                            callToActionColor: callToActionColor,
                            mainColor: mainColor,
                            backgroundColor: backgroundColor,
                            textColor: textColor)
                        
                        colorManager.changeCustomTheme(palette: palette)
                    } else {
                        colorManager.changeTeme(theme: theme)
                    }
                }
                .padding()
                .onDisappear {
                    if theme == .custom {
                        let palette = ColorPalette(
                            primaryColor: primaryColor,
                            fontColot: fontColot,
                            callToActionColor: callToActionColor,
                            mainColor: mainColor,
                            backgroundColor: backgroundColor,
                            textColor: textColor)
                        
                        colorManager.changeCustomTheme(palette: palette)
                    }
                }
            }
            .background(.white)
        }
        .background(Color(.amarilloML))
        .navigationBarBackButtonHidden(true)

    }
    
    @ViewBuilder
    var phone: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.black.opacity(0.1))
                .frame(width: 200, height: 400)
                .overlay(
                    VStack(spacing: 20) {
                        Rectangle()
                            .fill( theme == .custom ? backgroundColor : colorManager.backgroundColor)
                            .frame(width: 180, height: 310)
                            .overlay(
                                VStack {
                                    if theme != .custom {
                                        colorManager.mainColor
                                            .frame(height: 20)
                                    } else {
                                        mainColor
                                            .frame(height: 20)
                                    }
                                        
                                    
                                    Image(systemName: "photo")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(.gray.opacity(0.6))
                                    
                                    Text("Titulo")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(theme == .custom ? textColor : colorManager.textColor)
                                    
                                    Text("Censura animadverto eum ago utpote tot peccatus decimus debilito quis. Tollo cornu acsi stillicidium nobis curiositas benevolentia.")
                                        .font(.system(size: 10, weight: .regular))
                                        .foregroundStyle(theme == .custom ? fontColot : colorManager.fontColot)
                                        .padding(.horizontal)
                                    
                                    Text("Envio Gratis")
                                        .font(.system(size: 12, weight: .thin))
                                        .foregroundStyle(theme == .custom ? callToActionColor : colorManager.callToActionColor)
                                        .padding(.vertical, 10)
                                    Spacer()
                                    
                                    Button {
                                        
                                    } label: {
                                        Text("Button")
                                            .fontWeight(.light)
                                            .foregroundStyle(.white)
                                            .font(.system(size: 12))
                                            .padding(5)
                                    }
                                    .background(theme == .custom ? primaryColor : colorManager.primaryColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 3))
                                    .padding()
                                    
                                    if theme == .custom  {
                                        mainColor
                                            .frame(height: 20)
                                    } else {
                                        colorManager.mainColor
                                            .frame(height: 20)
                                    }
                                }
                            )
                        
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 30, height: 30)
                    }
                        .padding(.vertical, 20)
                )
        }
    }
}

struct DeveloperView_Previews: PreviewProvider {
    static let viewModel = HomeViewModel()
    
    static var previews: some View {
        NavigationWrapperView(
            destination: DestinationViewModel(),
            fabric: ScreenFabric(homeViewModel: viewModel)) {
                DeveloperView(viewModel: viewModel)
            }
            .environmentObject(ThemeManager())
    }
}
