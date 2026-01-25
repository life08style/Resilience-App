import SwiftUI

/// A shared card for displaying statistics in analytics views.
struct ChartStatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            HStack(alignment: .bottom, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}

/// A more detailed stat card used in progress and analytics hubs.
struct DetailedStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.subheadline)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

/// A small summary card for high-level stats.
struct SummaryMiniCard: View {
    let label: String
    let value: String
    let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(label).font(.system(size: 10)).foregroundColor(.gray)
            Text(value).font(.subheadline).fontWeight(.bold).foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.05))
        .cornerRadius(12)
    }
}

/// A shared legend item for charts.
struct SharedLegendItem: View {
    let label: String
    let color: Color
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label).font(.caption).foregroundColor(.gray)
        }
    }
}

/// A labeled metric for body measurements.
struct MetricLabel: View {
    let value: Double
    let unit: String
    let color: Color
    var body: some View {
        Text("\(String(format: "%.1f", value))\(unit)")
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .cornerRadius(6)
    }
}

/// A component for navigating through time periods in analytics.
struct DateNavigator: View {
    @Binding var date: Date
    let period: String // "Week", "Month", "Year"
    
    var body: some View {
        HStack {
            Button(action: { moveDate(by: -1) }) {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(dateRangeString)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(period)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)
            }
            
            Spacer()
            
            Button(action: { moveDate(by: 1) }) {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(isFuture ? .white.opacity(0.1) : .gray)
            }
            .disabled(isFuture)
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
    }
    
    private var isFuture: Bool {
        let calendar = Calendar.current
        let now = Date()
        
        switch period {
        case "Week":
            // Check if start of this week is >= start of current week
            return calendar.isDate(date, inSameDayAs: calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!) || date > now
        case "Month":
            return calendar.isDate(date, equalTo: now, toGranularity: .month) || date > now
        default:
            return calendar.isDate(date, equalTo: now, toGranularity: .year) || date > now
        }
    }
    
    private func moveDate(by offset: Int) {
        let calendar = Calendar.current
        let component: Calendar.Component
        let value: Int
        
        switch period {
        case "Month":
            component = .month
            value = offset
        case "Year":
            component = .year
            value = offset
        default:
            component = .day
            value = offset * 7
        }
        
        if let newDate = calendar.date(byAdding: component, value: value, to: date) {
            withAnimation {
                date = newDate
            }
            HapticManager.shared.impact()
        }
    }
    
    private var dateRangeString: String {
        let formatter = DateFormatter()
        
        if period == "Week" {
            formatter.dateFormat = "MMM d"
            let end = Calendar.current.date(byAdding: .day, value: 6, to: date) ?? date
            return "\(formatter.string(from: date)) - \(formatter.string(from: end))"
        } else if period == "Month" {
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: date)
        } else {
            formatter.dateFormat = "yyyy"
            return formatter.string(from: date)
        }
    }
}

/// A styled metric block as seen in premium analytics designs.
struct MetricBlockView: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
                .textCase(.uppercase)
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(color)
                Text(unit)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(color.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
