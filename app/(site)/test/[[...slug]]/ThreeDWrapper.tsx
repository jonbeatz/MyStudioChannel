"use client"

import dynamic from "next/dynamic"

export const AnimatedThreeDScene = dynamic(() => import("./ThreeDComponent"), {
  ssr: false,
  loading: () => (
    <div className="w-full h-[500px] bg-[#1a1a1a] rounded-3xl border border-[#D4AF37]/20 flex items-center justify-center animate-pulse">
      <div className="text-center">
        <span className="text-2xl block mb-2">🔄</span>
        <span className="text-sm text-gray-400 font-mono">Initializing 3D Canvas...</span>
      </div>
    </div>
  ),
})
