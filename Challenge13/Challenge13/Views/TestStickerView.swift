import SwiftUI

struct TestStickerView: View {
    
    @State var quantity: Int = 1
    
    private let adesivosPerSheet = 24
    
    private var sheetsNeeded: Int {
        guard quantity > 0 else { return 0 }
        return Int(ceil(Double(quantity) / Double(adesivosPerSheet)))
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            ReturnButton(action: {
                // coordinator.pop()
            })
            
            Text("Dicas")
                .font(.largeTitle)
            
            Text("Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit")
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 12)
    }
    
    // MARK: - Content
    private var content: some View {
        VStack(spacing: 28) {
            
//            Text("Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit")
//                .font(.body)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .fixedSize(horizontal: false, vertical: true)
            
            stepper
            a4Card
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Stepper
    private var stepper: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(white: 0.15))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.stickerPrimaryBorder), lineWidth: 4)
            )
            .overlay(
                VStack(spacing: 12) {
                    
                    Text("Quantidade de Adesivos")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    HStack {
                        
                        Button {
                            if quantity > 0 { quantity -= 1 }
                        } label: {
                            Circle()
                                .fill(Color(white: 0.25))
                                .frame(width: 44, height: 44)
                                .overlay(Text("−").foregroundColor(.white))
                        }
                        
                        Spacer()
                        
                        Text("\(quantity)")
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.96, green: 0.92, blue: 0.82))
                        
                        Spacer()
                        
                        Button {
                            quantity += 1
                        } label: {
                            Circle()
                                .fill(Color(white: 0.25))
                                .frame(width: 44, height: 44)
                                .overlay(Text("+").foregroundColor(.white))
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
            )
            .frame(height: 160)
    }
    
    // MARK: - A4 Card
    private var a4Card: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(white: 0.15))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.stickerPrimaryBorder), lineWidth: 4)
            )
            .frame(height: 60)
            .overlay(
                HStack(spacing: 8) {
                    Image(systemName: "doc")
                        .foregroundColor(.gray)
                        .font(.system(size: 32))
                    
                    Text("\(quantity) adesivos * \(sheetsNeeded) Folhas A4")
                        .foregroundColor(.white)
                }
            )
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            
            Color(.background)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        
                        header
                        
                        content
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TestStickerView(quantity: 4)
}
