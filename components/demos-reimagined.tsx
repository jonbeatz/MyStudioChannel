"use client"

import { useState } from "react"
import { motion, AnimatePresence } from "motion/react"
import { ZoomIn, ChevronLeft, ChevronRight } from "lucide-react"
import Image from "next/image"
import type { DemoProject } from "@/lib/cms/projects"
import { cn, useReducedMotion } from "@/lib/utils"
import { Skeleton } from "@/components/ui/skeleton"
import { DemosModal } from "@/components/demos-modal"

interface DemosReimaginedProps {
  projects: DemoProject[]
}

/** Robust, SSR-safe image component with shimmer skeleton overlay. */
function ImageWithSkeleton({
  src,
  alt,
  className,
}: {
  src: string
  alt: string
  className?: string
}) {
  const [loaded, setLoaded] = useState(false)
  const imageSrc = src || "/media/msc-background.jpg"
  return (
    <div className="relative w-full h-full bg-neutral-900 overflow-hidden">
      {!loaded && (
        <Skeleton className="absolute inset-0 z-10 w-full h-full bg-white/5 animate-pulse" />
      )}
      <Image
        src={imageSrc}
        alt={alt || "My Studio Channel project preview"}
        fill
        sizes="(max-width: 768px) 100vw, (max-width: 1024px) 50vw, 33vw"
        className={cn(
          className,
          "object-cover transition-all duration-700 ease-out",
          loaded ? "opacity-100 scale-100" : "opacity-0 scale-95"
        )}
        onLoad={() => setLoaded(true)}
      />
    </div>
  )
}

export function DemosReimagined({ projects }: DemosReimaginedProps) {
  const shouldReduceMotion = useReducedMotion()
  const [selectedProject, setSelectedProject] = useState<DemoProject | null>(null)
  const [isModalOpen, setIsModalOpen] = useState(false)
  
  // Pagination State
  const [currentPage, setCurrentPage] = useState(0)
  const itemsPerPage = 6
  const totalPages = Math.ceil(projects.length / itemsPerPage)
  const visibleProjects = projects.slice(
    currentPage * itemsPerPage,
    (currentPage + 1) * itemsPerPage
  )

  const handleCardClick = (project: DemoProject) => {
    setSelectedProject(project)
    setIsModalOpen(true)
  }

  // Animation variants
  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: { staggerChildren: 0.08, delayChildren: 0.2 },
    },
  }

  const itemVariants = {
    hidden: { opacity: 0, y: 30 },
    visible: {
      opacity: 1,
      y: 0,
      transition: { duration: 0.5, ease: [0.16, 1, 0.3, 1] as const },
    },
  }

  return (
    <section
      className="py-24 lg:py-32 relative bg-surface-2 msc-section msc-surface-2"
      data-divi-section="demos-reimagined"
    >
      <div id="msc-demos" className="relative z-10 mx-auto max-w-7xl px-6 lg:px-8 scroll-mt-30">
        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-2 rounded-full bg-accent/10 border border-accent/20 px-4 py-1.5 mb-6">
            <span className="h-1.5 w-1.5 rounded-full bg-accent animate-pulse" />
            <span className="text-xs font-medium uppercase tracking-wider text-accent">
              OUR WORK
            </span>
          </div>
          <h2 className="text-3xl font-bold tracking-tight text-foreground sm:text-4xl lg:text-5xl">
            MSC Demo Sites
          </h2>
          <div className="h-1 w-24 bg-accent mx-auto mt-4 rounded-full shadow-[0_0_12px_rgba(245,184,65,0.4)]" />
          <p className="mt-6 text-lg text-muted-foreground">
            Take a look at some of the creator platforms and studio-style websites we&apos;ve been building. More projects launching soon.
          </p>
        </div>

        {/* Bento Grid layout with page transitions */}
        <AnimatePresence mode="wait">
          <motion.div
            key={currentPage}
            variants={shouldReduceMotion ? {} : containerVariants}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true, margin: "-100px" }}
            animate={shouldReduceMotion ? { opacity: 1 } : { opacity: 1, x: 0 }}
            exit={shouldReduceMotion ? { opacity: 0 } : { opacity: 0, x: -20 }}
            transition={{ duration: 0.3, ease: "easeInOut" }}
            className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4"
          >
            {visibleProjects.map((project) => (
              <motion.div
                key={project.id}
                variants={shouldReduceMotion ? {} : itemVariants}
                onClick={() => handleCardClick(project)}
                className="glass-card rounded-2xl overflow-hidden cursor-pointer group flex flex-col h-[365px] border border-white/5 bg-black/40 shadow-lg hover:shadow-[0_10px_40px_rgba(0,0,0,0.4),0_0_25px_rgba(245,184,65,0.15)] hover:border-accent/50 hover:scale-[1.02] transition-all duration-300 relative"
              >
                {/* Category Badge */}
                {project.category && (
                  <span className="absolute top-3 left-3 z-10 bg-black/65 backdrop-blur-sm text-accent text-[10px] px-2.5 py-1 rounded-full border border-accent/30 font-bold uppercase tracking-widest">
                    {project.category}
                  </span>
                )}

                {/* Card Thumbnail */}
                <div className="relative w-full aspect-video flex-shrink-0 overflow-hidden bg-neutral-950">
                  <ImageWithSkeleton
                    src={project.image}
                    alt={project.title}
                    className="object-cover w-full h-full transition-transform duration-700 group-hover:scale-105"
                  />
                  {/* Top dark gradient overlay - only top 25% */}
                  <div className="absolute top-0 left-0 right-0 h-1/4 bg-gradient-to-b from-black/90 to-transparent z-[5] pointer-events-none" />

                  {/* Bottom dark gradient overlay for badge readability */}
                  <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent z-[5] pointer-events-none" />

                  {/* Zoom indicator on hover */}
                  <div className="absolute inset-0 bg-black/0 group-hover:bg-black/40 transition-all duration-300 flex items-center justify-center pointer-events-none">
                    <ZoomIn className="h-8 w-8 text-white opacity-0 group-hover:opacity-100 transition-all duration-300" />
                  </div>
                </div>

                {/* Text Container (fixed height, scrollable content) */}
                <div className="p-3 flex flex-col" style={{ height: '140px' }}>
                  {/* Title */}
                  <h3 className="text-lg font-semibold text-foreground line-clamp-1 flex-shrink-0 group-hover:text-accent transition-colors">
                    {project.title}
                  </h3>

                  {/* Description (scrollable) */}
                  <p className="text-sm text-muted-foreground mt-2 overflow-y-auto pr-1 flex-1">
                    {project.subtitle}
                  </p>
                </div>
              </motion.div>
            ))}
          </motion.div>
        </AnimatePresence>

        {/* Carousel Pagination Controls */}
        {projects.length > itemsPerPage && (
          <div className="flex justify-center items-center gap-4 mt-12">
            {/* Left arrow button */}
            <button
              onClick={() => setCurrentPage(prev => Math.max(0, prev - 1))}
              disabled={currentPage === 0}
              className="p-2 rounded-full bg-black/40 backdrop-blur-sm border border-white/10 text-white hover:bg-accent/20 hover:border-accent/50 hover:scale-110 transition-all duration-300 disabled:opacity-30 disabled:cursor-not-allowed disabled:hover:scale-100"
              aria-label="Previous page"
            >
              <ChevronLeft className="h-5 w-5" />
            </button>

            {/* Counter text */}
            <span className="text-sm text-muted-foreground font-medium select-none">
              {currentPage * itemsPerPage + 1}-
              {Math.min((currentPage + 1) * itemsPerPage, projects.length)} of {projects.length}
            </span>

            {/* Right arrow button */}
            <button
              onClick={() => setCurrentPage(prev => Math.min(totalPages - 1, prev + 1))}
              disabled={currentPage === totalPages - 1}
              className="p-2 rounded-full bg-black/40 backdrop-blur-sm border border-white/10 text-white hover:bg-accent/20 hover:border-accent/50 hover:scale-110 transition-all duration-300 disabled:opacity-30 disabled:cursor-not-allowed disabled:hover:scale-100"
              aria-label="Next page"
            >
              <ChevronRight className="h-5 w-5" />
            </button>
          </div>
        )}
      </div>

      {/* Detail Modal Component */}
      <AnimatePresence>
        {isModalOpen && (
          <DemosModal
            isOpen={isModalOpen}
            onClose={() => setIsModalOpen(false)}
            project={selectedProject}
          />
        )}
      </AnimatePresence>
    </section>
  )
}
