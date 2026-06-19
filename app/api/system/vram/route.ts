import { NextResponse } from 'next/server';
import { execFile } from 'child_process';
import { promisify } from 'util';
import net from 'net';
import path from 'path';

const execFileAsync = promisify(execFile);

const SERVICE_PORTS: { key: string; port: number }[] = [
  { key: 'devApp', port: 3000 },
  { key: 'taskBoard', port: 3001 },
  { key: 'workspace', port: 3005 },
  { key: 'dashboard', port: 9119 },
  { key: 'comfyUI', port: 8188 },
  { key: 'postiz', port: 4007 },
];

function checkPort(port: number): Promise<boolean> {
  return new Promise((resolve) => {
    const socket = new net.Socket();
    socket.setTimeout(300);

    socket.on('connect', () => {
      socket.destroy();
      resolve(true);
    });

    socket.on('timeout', () => {
      socket.destroy();
      resolve(false);
    });

    socket.on('error', () => {
      socket.destroy();
      resolve(false);
    });

    socket.connect(port, '127.0.0.1');
  });
}

export type ComfyUiState = {
  portListening?: boolean;
  processDetected?: boolean;
  pids?: number[];
  state?: 'stopped' | 'idle' | 'generating' | 'unknown';
  queueRunning?: number | null;
  queuePending?: number | null;
  queueError?: boolean;
};

export type LmStudioState = {
  running?: boolean;
  loadedModels?: string[];
  vramNote?: string;
};

type VramDiagnostics = {
  usedMb?: number;
  totalMb?: number;
  freeMb?: number;
  used?: string;
  total?: string;
  percent?: number;
  level?: string;
  lmStudioRunning?: boolean;
  comfyRunning?: boolean;
  comfyui?: ComfyUiState;
  lmStudio?: LmStudioState;
  processes?: Array<{
    pid: number;
    name: string;
    exe?: string;
    ramMb: number;
    gpuCompute: boolean;
  }>;
  recommendation?: string;
  wddmNote?: string;
  status?: string;
};

async function runVramDiagnostics(): Promise<VramDiagnostics | null> {
  if (process.platform !== 'win32') return null;

  const scriptPath = path.join(
    process.cwd(),
    '.cursor',
    'custom-scriptz',
    'vram-diagnostics.ps1',
  );

  try {
    const { stdout } = await execFileAsync(
      'powershell',
      ['-ExecutionPolicy', 'Bypass', '-NoProfile', '-File', scriptPath],
      { timeout: 20000, maxBuffer: 1024 * 512 },
    );
    return JSON.parse(stdout.trim()) as VramDiagnostics;
  } catch {
    return null;
  }
}

export async function GET() {
  if (process.env.NODE_ENV === 'production' && process.env.VERCEL === '1') {
    return NextResponse.json({
      used: '0.0',
      total: '16.0',
      percent: 0,
      level: 'healthy',
      services: {},
      allNominal: true,
      vramHealthy: true,
      status: 'production-disabled',
    });
  }

  try {
    const diag = await runVramDiagnostics();

    const serviceResults: Record<string, boolean> = {};

    for (const s of SERVICE_PORTS) {
      serviceResults[s.key] = await checkPort(s.port);
    }

    const comfyState = diag?.comfyui?.state ?? (diag?.comfyRunning ? 'idle' : 'stopped');
    if (comfyState !== 'stopped') {
      serviceResults.comfyUI = true;
    }

    const percent = diag?.percent ?? 0;
    const level = diag?.level ?? 'healthy';
    const vramHealthy = percent < 65;
    const allServicesUp = Object.entries(serviceResults).every(([key, active]) => {
      if (key === 'comfyUI' && comfyState === 'stopped') return true;
      return active;
    });

    return NextResponse.json({
      used: diag?.used ?? '0.0',
      total: diag?.total ?? '16.0',
      usedMb: diag?.usedMb ?? 0,
      totalMb: diag?.totalMb ?? 16311,
      freeMb: diag?.freeMb ?? 0,
      percent,
      level,
      vramHealthy,
      lmStudioRunning: diag?.lmStudioRunning ?? diag?.lmStudio?.running ?? false,
      comfyRunning: diag?.comfyRunning ?? comfyState !== 'stopped',
      comfyui: diag?.comfyui ?? {
        portListening: serviceResults.comfyUI ?? false,
        processDetected: false,
        pids: [],
        state: comfyState,
        queueRunning: null,
        queuePending: null,
        queueError: false,
      },
      lmStudio: diag?.lmStudio ?? {
        running: diag?.lmStudioRunning ?? false,
        loadedModels: [],
      },
      processes: diag?.processes ?? [],
      recommendation: diag?.recommendation ?? '',
      wddmNote: diag?.wddmNote ?? '',
      services: serviceResults,
      allNominal: allServicesUp && vramHealthy,
      status: diag?.status ?? 'success',
    });
  } catch (error: unknown) {
    const errMsg = error instanceof Error ? error.message : String(error);
    return NextResponse.json({
      used: '0.0',
      total: '16.0',
      percent: 0,
      level: 'unknown',
      services: {},
      allNominal: false,
      vramHealthy: false,
      status: 'error',
      message: errMsg,
    });
  }
}
