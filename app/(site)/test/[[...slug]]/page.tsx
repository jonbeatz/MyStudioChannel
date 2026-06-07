// NOTE: This page uses Next.js Fast Refresh. Edit any test component and save to see changes instantly.
import Link from 'next/link'
import { MSC_APP_VERSION } from '@/lib/msc-app-version'

export const metadata = {
  title: '🧪 Test Playground | MyStudioChannel',
  description: 'Isolated testing environment for UI components and design systems',
}

// This is a catch-all route that matches /test, /test/anything, /test/stripe-card, etc.
export default async function TestPage({ params }: { params: Promise<{ slug?: string[] }> }) {
  const { slug: slugArray } = await params
  const slug = slugArray || []
  const testName = slug.join('/') || 'index'
  
  return (
    <div className="min-h-screen bg-[#121212] text-white font-sans">
      {/* Test runner header - keeps your site branding but clearly marks as TEST */}
      <div className="sticky top-0 z-50 bg-[#1c1c1c] border-b border-[#D4AF37]/30 px-6 py-4 backdrop-blur-md">
        <div className="flex items-center justify-between max-w-7xl mx-auto">
          <div>
            <h1 className="text-xl font-bold flex items-center gap-2">
              <span className="text-2xl">🧪</span> Test Playground
              <span className="ml-2 px-2 py-0.5 text-[10px] font-mono bg-[#D4AF37]/20 text-[#D4AF37] rounded uppercase tracking-widest">
                {testName}
              </span>
            </h1>
            <p className="text-xs text-gray-400 mt-1">
              Isolated testing environment — nothing here affects production pages
            </p>
          </div>
          <div className="flex gap-3">
            <Link href="/test" className="text-xs px-4 py-1.5 rounded-full border border-gray-700 bg-gray-800/50 hover:bg-[#D4AF37]/10 hover:border-[#D4AF37]/40 transition-all">
              ← Playground Home
            </Link>
            <Link href="/" className="text-xs px-4 py-1.5 rounded-full bg-[#D4AF37] text-black font-bold hover:bg-[#b8962d] transition-all">
              Main Site
            </Link>
          </div>
        </div>
      </div>
      
      {/* Test content area - YOUR EXPERIMENTS GO HERE */}
      <div className="p-6 max-w-7xl mx-auto">
        {testName === 'index' && <TestIndex />}
        {testName === 'stripe-card' && <StripeCardTest />}
        {testName === 'supabase-card' && <SupabaseCardTest />}
        {testName === 'tesla-hero' && <TeslaHeroTest />}
        {testName === 'design-reference' && <DesignReferenceTest />}
        {testName === 'three-d' && <ThreeDTest />}
        {testName === 'sentry-crash' && <SentryCrashTest />}
        
        {!['index', 'stripe-card', 'supabase-card', 'tesla-hero', 'design-reference', 'three-d'].includes(testName) && (
          <div className="text-center py-32 border-2 border-dashed border-gray-800 rounded-3xl">
            <div className="text-6xl mb-6">🔍</div>
            <h2 className="text-3xl font-bold text-gray-300">Test Not Found</h2>
            <p className="text-gray-500 mt-4 max-w-md mx-auto">
              The route <code className="text-[#D4AF37] bg-[#D4AF37]/10 px-2 py-1 rounded">/test/{testName}</code> doesn&apos;t have a component assigned yet.
            </p>
            <div className="mt-8">
               <Link href="/test" className="text-[#D4AF37] hover:underline">Return to index</Link>
            </div>
          </div>
        )}
      </div>
      
      {/* Global Test Footer */}
      <footer className="mt-20 border-t border-gray-900 py-10 text-center">
        <div className="text-[10px] text-gray-600 font-mono tracking-tighter uppercase">
          MyStudioChannel Engine v{MSC_APP_VERSION} • Debug Mode: Active
        </div>
      </footer>
    </div>
  )
}

// ============ TEST COMPONENTS (ISOLATED) ============

function TestIndex() {
  const tests = [
    {
      id: 'stripe-card',
      title: 'Stripe Card',
      desc: "Premium SaaS design with purple gradients and backdrop blurs.",
      file: 'DESIGN-STRIPE.md',
      icon: '💜'
    },
    {
      id: 'supabase-card',
      title: 'Supabase Card',
      desc: "Developer-centric dark emerald design with high-contrast borders.",
      file: 'DESIGN-SUPABASE.md',
      icon: '⚡'
    },
    {
      id: 'tesla-hero',
      title: 'Tesla Hero',
      desc: "Minimalist, radical subtraction with ultra-thin typography.",
      file: 'DESIGN-TESLA.md',
      icon: '🏎️'
    },
    {
      id: 'design-reference',
      title: 'Design Reference',
      desc: "Viewer for all available tokens from extraction logs.",
      file: 'Multiple',
      icon: '📁'
    },
    {
      id: 'three-d',
      title: '3D Scene (Three.js & R3F)',
      desc: "Interactive 3D canvas rendering an animated geometric globe using React Three Fiber.",
      file: 'ThreeJS',
      icon: '🌐'
    },
    {
      id: 'sentry-crash',
      title: 'Sentry Crash Diagnostic',
      desc: "Trigger a client-side or server-side error to verify Sentry event pipeline reporting.",
      file: 'Sentry',
      icon: '🚨'
    }
  ]

  return (
    <div className="max-w-5xl mx-auto space-y-12 py-10">
      <div className="space-y-4">
        <h2 className="text-4xl font-extrabold tracking-tight">Test Playground</h2>
        <p className="text-xl text-gray-400 max-w-2xl">
          Rapidly prototype components in total isolation. No database calls, no CMS overhead, just pure UI experimentation.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {tests.map(t => (
          <Link 
            key={t.id} 
            href={`/test/${t.id}`} 
            className="group block p-1 rounded-2xl bg-gradient-to-br from-gray-800 to-gray-900 hover:from-[#D4AF37]/40 hover:to-[#D4AF37]/10 transition-all duration-300 shadow-xl"
          >
            <div className="bg-[#1c1c1c] rounded-xl p-6 h-full border border-white/5 group-hover:border-transparent transition-all">
              <div className="flex justify-between items-start mb-4">
                <div className="w-12 h-12 rounded-lg bg-gray-800 flex items-center justify-center text-2xl">
                  {t.icon}
                </div>
                <div className="font-mono text-[10px] text-[#D4AF37] uppercase tracking-widest bg-[#D4AF37]/10 px-2 py-1 rounded">
                  {t.file}
                </div>
              </div>
              <h3 className="text-xl font-bold mb-2 group-hover:text-[#D4AF37] transition-colors">{t.title}</h3>
              <p className="text-gray-400 text-sm leading-relaxed">{t.desc}</p>
              <div className="mt-6 flex items-center text-xs font-bold text-[#D4AF37] opacity-0 group-hover:opacity-100 transition-opacity">
                OPEN EXPERIMENT <span className="ml-2">→</span>
              </div>
            </div>
          </Link>
        ))}
      </div>
      
      <div className="p-8 rounded-3xl bg-blue-500/5 border border-blue-500/20">
        <div className="flex gap-4">
          <div className="text-2xl">💡</div>
          <div>
            <h3 className="font-bold text-blue-400">Pro-tip: Adding New Tests</h3>
            <p className="text-sm text-gray-400 mt-1 leading-relaxed">
              Open <code className="text-blue-300 bg-blue-900/30 px-1 rounded">app/test/[[...slug]]/page.tsx</code>, 
              create a new function component at the bottom, and add its ID to the switch logic in <code className="text-blue-300 bg-blue-900/30 px-1 rounded">TestPage</code>.
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}

function StripeCardTest() {
  // Reference: .cursor/DesignMD/DESIGN-STRIPE.md
  return (
    <div className="py-20 flex flex-col items-center">
      <div className="w-full max-w-sm">
        <div className="relative group">
          {/* Stripe-style glow */}
          <div className="absolute -inset-1 bg-gradient-to-r from-[#635bff] to-[#00d4ff] rounded-2xl blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"></div>
          
          <div className="relative bg-[#1c1c1c] border border-white/10 rounded-2xl overflow-hidden shadow-2xl">
            <div className="h-2 bg-gradient-to-r from-[#635bff] to-[#00d4ff]"></div>
            <div className="p-8">
              <div className="flex justify-between items-center mb-8">
                <span className="text-xs font-bold uppercase tracking-widest text-[#635bff]">Starter</span>
                <span className="bg-[#635bff]/10 text-[#635bff] text-[10px] font-bold px-2 py-0.5 rounded-full">Popular</span>
              </div>
              
              <div className="mb-8">
                <span className="text-5xl font-extrabold tracking-tight">$49</span>
                <span className="text-gray-500 ml-2">/mo</span>
              </div>
              
              <p className="text-sm text-gray-400 mb-8 leading-relaxed">
                Unlock professional-grade studio features with our core platform.
              </p>
              
              <ul className="space-y-4 mb-10">
                {['Custom branding', 'Unlimited projects', '24/7 Support', 'API Access'].map(f => (
                  <li key={f} className="flex items-center gap-3 text-sm">
                    <div className="w-5 h-5 rounded-full bg-[#635bff]/20 flex items-center justify-center text-[#635bff]">
                      <svg className="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                      </svg>
                    </div>
                    {f}
                  </li>
                ))}
              </ul>
              
              <button className="w-full py-4 bg-[#635bff] hover:bg-[#5249d9] text-white font-bold rounded-lg transition-all shadow-[0_4px_14px_0_rgba(99,91,255,0.39)]">
                Get Started
              </button>
            </div>
          </div>
        </div>
      </div>
      
      <div className="mt-20 p-6 rounded-xl bg-gray-900 border border-gray-800 max-w-2xl">
        <h4 className="text-xs font-bold text-gray-500 uppercase tracking-widest mb-4">Design Tokens (DESIGN-STRIPE.md)</h4>
        <div className="grid grid-cols-2 gap-4">
          <div className="flex items-center gap-2">
            <div className="w-4 h-4 rounded bg-[#635bff]"></div>
            <span className="text-xs font-mono text-gray-400">#635BFF (Primary)</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-4 h-4 rounded bg-[#00D4FF]"></div>
            <span className="text-xs font-mono text-gray-400">#00D4FF (Accent)</span>
          </div>
        </div>
      </div>
    </div>
  )
}

function SupabaseCardTest() {
  // Reference: .cursor/DesignMD/DESIGN-SUPABASE.md
  return (
    <div className="py-20 flex flex-col items-center">
      <div className="w-full max-w-sm">
        <div className="bg-[#1c1c1c] border border-[#2e7d64] rounded-xl p-8 shadow-2xl relative overflow-hidden group">
          {/* Subtle grid pattern background */}
          <div className="absolute inset-0 opacity-[0.03] pointer-events-none bg-[url('https://www.transparenttextures.com/patterns/carbon-fibre.png')]"></div>
          
          <div className="relative z-10">
            <div className="w-12 h-12 bg-[#2e7d64]/20 border border-[#2e7d64]/40 rounded-lg flex items-center justify-center mb-6">
              <span className="text-2xl">⚡</span>
            </div>
            
            <h3 className="text-2xl font-bold mb-2">Supabase Engine</h3>
            <p className="text-gray-400 text-sm mb-8 leading-relaxed">
              Dark-mode optimized UI for developer tooling. High contrast emerald accents.
            </p>
            
            <div className="space-y-3 mb-8">
              <div className="flex justify-between items-center p-3 bg-black/40 rounded border border-white/5">
                <span className="text-xs text-gray-400 font-mono">Status</span>
                <span className="text-xs text-[#2e7d64] font-bold">● Active</span>
              </div>
              <div className="flex justify-between items-center p-3 bg-black/40 rounded border border-white/5">
                <span className="text-xs text-gray-400 font-mono">Region</span>
                <span className="text-xs text-white">US-EAST-1</span>
              </div>
            </div>
            
            <button className="w-full py-2 bg-[#2e7d64] hover:bg-[#23604d] text-white font-bold rounded transition-colors border border-[#3e9d7f]">
              Provision Database
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}

function TeslaHeroTest() {
  // Reference: .cursor/DesignMD/DESIGN-TESLA.md
  return (
    <div className="relative h-[600px] w-full bg-black rounded-3xl overflow-hidden group">
      <div className="absolute inset-0 bg-gradient-to-t from-black via-black/20 to-transparent z-10"></div>
      
      {/* Simulated background image */}
      <div className="absolute inset-0 bg-[#0a0a0a] flex items-center justify-center opacity-40 group-hover:opacity-60 transition-opacity duration-1000">
         <div className="w-full h-full bg-[radial-gradient(circle_at_center,_var(--tw-gradient-stops))] from-gray-800 to-black"></div>
      </div>

      <div className="relative z-20 h-full flex flex-col items-center justify-between py-20 px-6">
        <div className="text-center animate-in fade-in slide-in-from-top duration-1000">
          <h1 className="text-6xl md:text-8xl font-light tracking-tighter text-white mb-4">
            Model S
          </h1>
          <p className="text-white text-lg font-normal tracking-wide">
            Plaid Performance
          </p>
        </div>

        <div className="flex flex-col md:flex-row gap-4 w-full max-w-md animate-in fade-in slide-in-from-bottom duration-1000 delay-300">
          <button className="flex-1 py-3 bg-white/90 hover:bg-white text-black text-sm font-bold rounded-full transition-all">
            Order Now
          </button>
          <button className="flex-1 py-3 bg-gray-900/60 hover:bg-gray-900/80 backdrop-blur-md text-white text-sm font-bold rounded-full border border-white/10 transition-all">
            Demo Drive
          </button>
        </div>
      </div>
      
      <div className="absolute bottom-6 left-1/2 -translate-x-1/2 z-20 animate-bounce">
        <svg className="w-6 h-6 text-white/40" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </div>
    </div>
  )
}

function DesignReferenceTest() {
  const references = [
    { name: 'DESIGN-STRIPE.md', color: 'bg-purple-600', text: 'Premium SaaS, Purple Gradients' },
    { name: 'DESIGN-SUPABASE.md', color: 'bg-emerald-600', text: 'Developer Tools, Emerald/Dark' },
    { name: 'DESIGN-TESLA.md', color: 'bg-white', text: 'Minimalist Luxury, Black/White' },
    { name: 'DESIGN-APPLE.md', color: 'bg-gray-400', text: 'Minimalist Soft-Grey, Large White Space' },
    { name: 'DESIGN-LINEAR.md', color: 'bg-indigo-600', text: 'Professional Focus, High Density' },
  ]

  return (
    <div className="max-w-4xl mx-auto py-10 space-y-8">
      <div className="space-y-2">
        <h2 className="text-3xl font-bold">Design References</h2>
        <p className="text-gray-400">Extracted tokens and principles from .cursor/DesignMD/</p>
      </div>

      <div className="grid gap-4">
        {references.map(ref => (
          <div key={ref.name} className="flex items-center gap-4 p-4 bg-[#1c1c1c] border border-white/5 rounded-xl hover:border-[#D4AF37]/40 transition-all">
            <div className={`w-3 h-12 rounded-full ${ref.color}`}></div>
            <div className="flex-1">
              <div className="font-mono text-sm text-white">{ref.name}</div>
              <div className="text-xs text-gray-500 mt-1">{ref.text}</div>
            </div>
            <div className="text-[10px] font-mono text-gray-600">READY</div>
          </div>
        ))}
      </div>
      
      <div className="p-8 rounded-2xl bg-[#D4AF37]/5 border border-[#D4AF37]/20">
        <h3 className="font-bold text-[#D4AF37] mb-4 flex items-center gap-2">
          <span>📚</span> Engineering Workflow
        </h3>
        <div className="space-y-4 text-sm text-gray-400 leading-relaxed">
          <p>
            1. Use <code className="text-[#D4AF37] bg-black/40 px-1 rounded">npm run dmd [url]</code> to extract a new design system.
          </p>
          <p>
            2. The file will be saved in <code className="text-[#D4AF37] bg-black/40 px-1 rounded">.cursor/DesignMD/</code>.
          </p>
          <p>
            3. Reference the markdown file while building a new <code className="text-[#D4AF37] bg-black/40 px-1 rounded">TestComponent</code> here.
          </p>
          <p>
            4. Once perfected, move the component to <code className="text-[#D4AF37] bg-black/40 px-1 rounded">components/</code> for production use.
          </p>
        </div>
      </div>
    </div>
  )
}

// 3D Test Component dynamically imported on the client to bypass Next.js SSR mismatch issues
import { AnimatedThreeDScene } from './ThreeDWrapper'
import SentryCrashComponent from './SentryCrashComponent'

function SentryCrashTest() {
  return <SentryCrashComponent />
}

function ThreeDTest() {
  return (
    <div className="max-w-4xl mx-auto py-10 space-y-8">
      <div className="space-y-2">
        <h2 className="text-3xl font-bold">Interactive 3D Experiment</h2>
        <p className="text-gray-400">
          Powered by <strong className="text-white">Three.js</strong>, <strong className="text-white">React Three Fiber (R3F)</strong>, and <strong className="text-white">@react-three/drei</strong>. Fully React 19 & Next.js 15 compatible.
        </p>
      </div>

      <div className="relative">
        <AnimatedThreeDScene />
      </div>

      <div className="p-8 rounded-2xl bg-purple-500/5 border border-purple-500/20">
        <h3 className="font-bold text-purple-400 mb-4 flex items-center gap-2">
          <span>🎮</span> Interactive Controls
        </h3>
        <ul className="space-y-2 text-sm text-gray-400 list-disc list-inside">
          <li><strong>Rotate:</strong> Click and drag anywhere on the canvas to rotate the viewport.</li>
          <li><strong>Zoom:</strong> Use your mouse wheel or trackpad pinch gestures to zoom in and out.</li>
          <li><strong>Pan:</strong> Hold <code className="bg-black/40 px-1 rounded font-mono text-purple-300">Shift</code> and drag to move the camera focus.</li>
          <li><strong>Hover:</strong> Hover over the meshes to trigger visual feedback (color changes/scaling).</li>
        </ul>
      </div>
    </div>
  )
}

