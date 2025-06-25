//
//  CircularProgressView.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 12/11/2024.
//

import SwiftUI

struct CircularProgressView: View {
  @Binding var progress: Double

  var body: some View {
    ZStack {
      Circle()
        .stroke(
          Color.orange.opacity(0.5),
          lineWidth: 8
        )
      Circle()
        .trim(from: 0, to: progress)
        .stroke(
          Color.blue,
          style: StrokeStyle(
            lineWidth: 8,
            lineCap: .round
          )
        )
        .rotationEffect(.degrees(-90))
        .animation(.easeOut, value: progress)
    }
  }
}

#Preview {
  CircularProgressView(progress: .constant(6.0 / 12.0))
    .frame(width: 50, height: 50)
}
