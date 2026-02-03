import SwiftUI

struct SubscriptionView: View {
    var body: some View {
        ResiliencePage(showBackButton: true) {
            ScrollView {
                VStack(spacing: 32) {
                    // Header Image / Hero
                    VStack(spacing: 16) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom))
                            .padding(.top, 40)
                        
                        Text("Unlock Premium")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        
                        Text("Supercharge your productivity and fitness journey.")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    
                    // Features List
                    VStack(alignment: .leading, spacing: 20) {
                        FeatureRow(icon: "brain.head.profile", title: "Advanced AI Coaching", description: "Unlimited personalized advice")
                        FeatureRow(icon: "chart.xyaxis.line", title: "Detailed Analytics", description: "Deep dive into your stats")
                        FeatureRow(icon: "cloud.fill", title: "Cloud Sync", description: "Access data across all devices")
                        FeatureRow(icon: "lock.open.fill", title: "Unlimited Habits", description: "Track as many habits as you want")
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6).opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // Pricing Cards
                    HStack(spacing: 16) {
                        PricingCard(title: "Monthly", price: "$9.99", period: "/mo", isPopular: false)
                        PricingCard(title: "Yearly", price: "$79.99", period: "/yr", isPopular: true)
                    }
                    .padding(.horizontal)
                    
                    // CTA Button
                    Button(action: {}) {
                        Text("Start 7-Day Free Trial")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.yellow, .orange], startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                    
                    Text("Restore Purchases")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .underline()
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.yellow)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct PricingCard: View {
    let title: String
    let price: String
    let period: String
    let isPopular: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            if isPopular {
                Text("BEST VALUE")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.yellow)
                    .cornerRadius(8)
            } else {
                Text("")
                    .font(.caption2)
                    .padding(.vertical, 4)
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(price)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(period)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(isPopular ? "Save 33%" : "Flexible")
                .font(.caption)
                .foregroundColor(.green)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isPopular ? Color.yellow : Color.clear, lineWidth: 2)
        )
    }
}
