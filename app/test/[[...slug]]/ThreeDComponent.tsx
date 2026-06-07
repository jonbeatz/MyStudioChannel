"use client"

import { useRef, useState } from "react"
import { Canvas, useFrame } from "@react-three/fiber"
import { OrbitControls, Stars, Float, MeshDistortMaterial } from "@react-three/drei"
import * as THREE from "three"

function TorusKnot() {
  const meshRef = useRef<THREE.Mesh>(null)
  const [hovered, setHovered] = useState(false)
  const [clicked, setClicked] = useState(false)

  // Rotate the mesh on every frame
  useFrame((state, delta) => {
    if (meshRef.current) {
      meshRef.current.rotation.x += delta * 0.5
      meshRef.current.rotation.y += delta * 0.2
    }
  })

  return (
    <Float speed={2} rotationIntensity={1} floatIntensity={1}>
      <mesh
        ref={meshRef}
        onClick={() => setClicked(!clicked)}
        onPointerOver={() => setHovered(true)}
        onPointerOut={() => setHovered(false)}
        scale={clicked ? 1.3 : 1.0}
      >
        <torusKnotGeometry args={[1, 0.3, 120, 16]} />
        <MeshDistortMaterial
          color={hovered ? "#D4AF37" : "#635bff"}
          attach="material"
          distort={0.4}
          speed={3}
          roughness={0.2}
          metalness={0.8}
        />
      </mesh>
    </Float>
  )
}

function FloatingSpheres() {
  const count = 30
  const tempObject = new THREE.Object3D()
  const meshRef = useRef<THREE.InstancedMesh>(null)

  useFrame((state) => {
    const time = state.clock.getElapsedTime()
    let i = 0
    for (let x = 0; x < 5; x++) {
      for (let y = 0; y < 3; y++) {
        for (let z = 0; z < 2; z++) {
          const id = i++
          tempObject.position.set(
            (x - 2) * 2.5 + Math.sin(time + id) * 0.2,
            (y - 1) * 2.5 + Math.cos(time + id) * 0.2,
            (z - 0.5) * 2.5 + Math.sin(time + id) * 0.2
          )
          tempObject.updateMatrix()
          if (meshRef.current) {
            meshRef.current.setMatrixAt(id, tempObject.matrix)
          }
        }
      }
    }
    if (meshRef.current) {
      meshRef.current.instanceMatrix.needsUpdate = true
    }
  })

  /* eslint-disable @typescript-eslint/no-explicit-any */
  return (
    <instancedMesh ref={meshRef} args={[null as any, null as any, count]}>
      <sphereGeometry args={[0.15, 16, 16]} />
      <meshStandardMaterial color="#38B2AC" roughness={0.1} metalness={0.5} />
    </instancedMesh>
  )
  /* eslint-enable @typescript-eslint/no-explicit-any */
}

export default function ThreeDComponent() {
  return (
    <div className="w-full h-[500px] bg-gradient-to-b from-[#111] to-[#1a1a1a] rounded-3xl border border-[#D4AF37]/20 overflow-hidden shadow-2xl relative">
      <Canvas camera={{ position: [0, 0, 5], fov: 60 }}>
        {/* Lights */}
        <ambientLight intensity={0.5} />
        <directionalLight position={[10, 10, 5]} intensity={1.5} color="#ffffff" />
        <pointLight position={[-10, -10, -5]} intensity={1.0} color="#D4AF37" />

        {/* 3D Elements */}
        <TorusKnot />
        <FloatingSpheres />

        {/* Background Atmosphere */}
        <Stars radius={100} depth={50} count={5000} factor={4} saturation={0} fade speed={1} />

        {/* View Controls */}
        <OrbitControls enableZoom={true} maxPolarAngle={Math.PI / 1.8} minDistance={2} maxDistance={15} />
      </Canvas>
      <div className="absolute top-4 left-4 bg-black/60 backdrop-blur-md px-3 py-1.5 rounded-full border border-white/10 flex items-center gap-2 pointer-events-none">
        <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
        <span className="text-xs font-mono text-gray-300">R3F Active Render View</span>
      </div>
    </div>
  )
}
