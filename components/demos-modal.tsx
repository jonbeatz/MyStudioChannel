"use client"

import { useEffect } from "react"
import { motion } from "motion/react"
import { X, ExternalLink } from "lucide-react"
import Image from "next/image"
import type { DemoProject } from "@/lib/cms/projects"
import { Button } from "@/components/ui/button"

interface DemosModalProps {
  isOpen: boolean
  onClose: () => void
  project: DemoProject | null
}

export function DemosModal({ isOpen, onClose, project }: DemosModalProps) {
  // Handle ESC key press to close modal
  useEffect(() => {
    if (!isOpen) return

    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") {
        onClose()
      }
    }

    window.addEventListener("keydown", handleKeyDown)
    return () => {
      window.removeEventListener("keydown", handleKeyDown)
    }
  }, [isOpen, onClose])

  if (!isOpen || !project) return null

  return (
    <div className="fixed inset-0 z-100 flex items-center justify-center p-4 sm:p-6 md:p-10">
      {/* Backdrop */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        transition={{ duration: 0.2 }}
        className="absolute inset-0 bg-black/85 backdrop-blur-xl"
        onClick={onClose}
      />

      {/* Modal Content Panel */}
      <motion.div
        initial={{ scale: 0.95, opacity: 0, y: 20 }}
        animate={{ scale: 1, opacity: 1, y: 0 }}
        exit={{ scale: 0.95, opacity: 0, y: 20 }}
        transition={{ type: "spring", damping: 30, stiffness: 350 }}
        className="relative w-full max-w-4xl max-h-[90vh] overflow-y-auto glass-modal rounded-3xl bg-black/80 shadow-[0_0_50px_rgba(245,184,65,0.1)] border border-accent/20 z-10 flex flex-col scrollbar-thin scrollbar-thumb-accent/20 scrollbar-track-transparent"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Close Button */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 z-20 h-10 w-10 rounded-full bg-black/60 border border-white/10 hover:border-accent/40 text-foreground hover:text-accent hover:scale-105 transition-all duration-300 flex items-center justify-center cursor-pointer"
          aria-label="Close modal"
        >
          <X className="h-5 w-5" />
        </button>

        <div className="flex flex-col md:grid md:grid-cols-12 md:items-stretch h-full">
          {/* Left/Top: Hero Image Container */}
          <div className="md:col-span-7 relative aspect-video md:aspect-auto min-h-[240px] sm:min-h-[300px] md:min-h-full bg-neutral-950 overflow-hidden group">
            <Image
              src={project.image}
              alt={project.title}
              fill
              priority
              sizes="(max-width: 768px) 100vw, 50vw"
              className="object-cover transition-transform duration-1000 group-hover:scale-105"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-black via-black/20 to-transparent md:bg-gradient-to-r md:from-transparent md:to-black/40" />
          </div>

          {/* Right/Bottom: Text Content Area */}
          <div className="md:col-span-5 p-6 sm:p-8 flex flex-col justify-between bg-black/20 backdrop-blur-xs min-h-[300px] md:min-h-full">
            <div>
              {/* Category Badge */}
              <span className="inline-block bg-accent/10 border border-accent/30 text-accent text-xs px-2.5 py-1 rounded-full font-semibold uppercase tracking-widest mb-4">
                {project.category}
              </span>

              {/* Title */}
              <h2 className="text-2xl sm:text-3xl font-bold text-foreground tracking-tight leading-tight">
                {project.title}
              </h2>

              {/* Description */}
              <p className="mt-4 text-sm sm:text-base text-muted-foreground leading-relaxed whitespace-pre-line">
                {project.subtitle}
              </p>
            </div>

            {/* CTA Buttons */}
            <div className="mt-8 pt-6 border-t border-white/5">
              <Button
                asChild
                className="w-full bg-accent text-accent-foreground hover:bg-accent/90 h-12 text-sm font-semibold rounded-xl glow-accent-sm hover:glow-accent transition-all duration-300 cursor-pointer"
              >
                <a
                  href={project.demoUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center justify-center gap-2"
                >
                  View Live Demo
                  <ExternalLink className="h-4 w-4" />
                </a>
              </Button>
            </div>
          </div>
        </div>
      </motion.div>
    </div>
  )
}
