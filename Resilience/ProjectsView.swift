import SwiftUI

struct ProjectsView: View {
    @State private var selectedTab = "Projects"
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            VStack(spacing: 24) {
                // Header (with Tab Switcher)
                VStack(spacing: 16) {
                    Text("Productivity Hub")
                        .font(.title2).fontWeight(.black).foregroundColor(.white)
                    
                    HStack {
                        Button(action: { selectedTab = "Projects" }) {
                            Text("Projects")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedTab == "Projects" ? Color.blue : Color.white.opacity(0.1))
                                .foregroundColor(selectedTab == "Projects" ? .white : .gray)
                                .cornerRadius(12)
                        }
                        
                        Button(action: { selectedTab = "Skills" }) {
                            Text("Skills")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedTab == "Skills" ? Color.pink : Color.white.opacity(0.1))
                                .foregroundColor(selectedTab == "Skills" ? .white : .gray)
                                .cornerRadius(12)
                        }
                    }
                    .padding(4)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(16)
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Large Actions
                        HStack(spacing: 16) {
                            Button(action: {}) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(selectedTab == "Projects" ? .blue : .pink)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Manual Add")
                                            .font(.headline).bold().foregroundColor(.white)
                                        Text("Create new")
                                            .font(.caption).foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 120)
                                .background(Color(UIColor.systemGray6).opacity(0.15))
                                .cornerRadius(16)
                            }
                            
                            Button(action: {}) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Image(systemName: "sparkles")
                                        .font(.largeTitle)
                                        .foregroundColor(selectedTab == "Projects" ? .cyan : .purple)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("AI Generate")
                                            .font(.headline).bold().foregroundColor(.white)
                                        Text("Let AI Build")
                                            .font(.caption).foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 120)
                                .background(Color(UIColor.systemGray6).opacity(0.15))
                                .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Empty State
                        VStack(spacing: 16) {
                            Image(systemName: selectedTab == "Projects" ? "hammer.fill" : "brain.head.profile")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.3))
                            
                            Text("No \(selectedTab) Yet")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text("Start building your legacy today.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 40)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
}
