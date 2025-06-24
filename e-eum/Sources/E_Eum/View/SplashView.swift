import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Image("eeum_icon", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160, height: 160)
            
            Spacer()
            
            Text("powered by KakaoImpact")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.black)
                .padding(.bottom, 32)
        }
        .preferredColorScheme(.light)
    }
}
