"use client";

export default function SentryCrashComponent() {
  return (
    <div className="max-w-4xl mx-auto py-10 space-y-8">
      <div className="space-y-2">
        <h2 className="text-3xl font-bold">Sentry Crash Diagnostic</h2>
        <p className="text-gray-400">
          Trigger simulated events to verify that your <strong className="text-white">Sentry DSN</strong> and <strong className="text-white">Auth Token</strong> integration is operating successfully.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="p-8 rounded-2xl bg-red-500/5 border border-red-500/20 space-y-4">
          <h3 className="text-xl font-bold text-red-400 flex items-center gap-2">
            <span>💻</span> Client-Side Crash
          </h3>
          <p className="text-sm text-gray-400 leading-relaxed">
            Clicking this button will execute an unhandled exception on your browser thread. Sentry will capture the exception and map it to your source code trace instantly.
          </p>
          <button 
            onClick={() => {
              throw new Error("Simulated Client-Side Exception from MyStudioChannel Dev Playground!");
            }}
            className="px-6 py-3 bg-red-600 hover:bg-red-700 text-white font-bold rounded-lg transition-all"
          >
            Trigger Client Exception
          </button>
        </div>

        <div className="p-8 rounded-2xl bg-amber-500/5 border border-amber-500/20 space-y-4">
          <h3 className="text-xl font-bold text-amber-400 flex items-center gap-2">
            <span>⚙️</span> Server-Side Trace API
          </h3>
          <p className="text-sm text-gray-400 leading-relaxed">
            Triggering this button calls a dedicated test API endpoint. The server will capture the payload, generate a transaction span, and throw a handled backend exception reported straight to Sentry.
          </p>
          <button 
            onClick={async () => {
              try {
                const res = await fetch('/api/dev/sentry-test');
                const data = await res.json();
                alert(`API Response: ${data.message || 'Error occurred'}`);
              } catch (err) {
                alert(`Network Fetch Failed: ${err}`);
              }
            }}
            className="px-6 py-3 bg-amber-600 hover:bg-amber-700 text-white font-bold rounded-lg transition-all"
          >
            Trigger Server API Crash
          </button>
        </div>
      </div>
    </div>
  );
}
