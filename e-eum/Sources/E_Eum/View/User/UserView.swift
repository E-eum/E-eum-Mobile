import SwiftUI

struct UserView: View {
    @Environment(AuthService.self) private var authService
    
    @Binding var qrAuthorized: Bool
    
    @State private var qrCode: String = ""
    @State private var showQRScanner: Bool = false
    @State private var showOnboarding: Bool = false
    @State private var showSignOutAlert: Bool = false
    @State private var showDeactivateAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text("유저 로그인 및 인증 정보, 설정 등이 들어갈 화면입니다.")
            
            if authService.userInfo != nil && !qrAuthorized {
                BasicButton(title: "QR코드 스캔하기", disabled: .constant(false)) {
                    showQRScanner = true
                }
                .frame(width: 200)
            }
            
            Button {
                UserDefaults.standard.set(false, forKey: "launchedBefore")
            } label: {
                Text("온보딩 보기 설정 초기화")
            }
            
            Button {
                showOnboarding = true
            } label: {
                Text("앱 소개 보기")
            }
            .fullScreenCover(isPresented: $showOnboarding) {
                OnboardingView(withHeader: true)
            }
            
            Spacer()
            
            if authService.userInfo != nil {
                HStack {
                    Button {
                        showSignOutAlert = true
                    } label: {
                        Text("로그아웃")
                            .underline()
                            .foregroundStyle(Color.gray)
                    }
                    
                    Button {
                        showDeactivateAlert = true
                    } label: {
                        Text("회원탈퇴")
                            .underline()
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
        .padding(16)
        .sheet(isPresented: $showQRScanner) {
            QRScannerView(qrCode: $qrCode)
                .onDisappear {
                    if qrCode != "" {
                        qrAuthorization()
                    }
                }
        }
        .alert("로그아웃 하시겠습니까?", isPresented: $showSignOutAlert) {
            Button(role: .cancel) {
                showSignOutAlert = false
            } label: {
                Text("취소")
            }
            
            Button(role: .destructive) {
                signOut()
            } label: {
                Text("로그아웃")
            }
        }
        .alert("회원탈퇴 하시겠습니까?", isPresented: $showDeactivateAlert) {
            Button(role: .cancel) {
                showDeactivateAlert = false
            } label: {
                Text("취소")
            }
            
            Button(role: .destructive) {
                deactivate()
            } label: {
                Text("회원탈퇴")
            }
        }
    }
}

private extension UserView {
    func qrAuthorization() {
        Task {
            do {
                authService.qrAuthorized = try await authService.qrAuthorization(qrCode: qrCode)
                qrAuthorized = authService.qrAuthorized
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func signOut() {
        Task {
            do {
                let result = try await authService.signout()
                if result {
                    qrAuthorized = false
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deactivate() {
        Task {
            do {
                _ = try await authService.deactivate()
                authService.userInfo = nil
                authService.qrAuthorized = false
                qrAuthorized = false
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
