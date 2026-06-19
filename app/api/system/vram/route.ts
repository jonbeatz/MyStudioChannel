import { NextResponse } from 'next/server';
import { exec } from 'child_process';
import { promisify } from 'util';
import net from 'net';

const execAsync = promisify(exec);

// Helper to check if a local port is listening
function checkPort(port: number): Promise<boolean> {
  return new Promise((resolve) => {
    const socket = new net.Socket();
    socket.setTimeout(300); // quick timeout

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

export async function GET() {
  // Only execute this check on localhost/development to avoid running local shell tools in production
  if (process.env.NODE_ENV === 'production' && process.env.VERCEL === '1') {
    return NextResponse.json({
      used: '0.0',
      total: '16.0',
      percent: 0,
      services: {},
      allNominal: true,
      status: 'production-disabled'
    });
  }

  try {
    let usedRaw = '';
    let totalRaw = '';
    
    try {
      const { stdout: usedRes } = await execAsync('nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits');
      const { stdout: totalRes } = await execAsync('nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits');
      usedRaw = usedRes.trim();
      totalRaw = totalRes.trim();
    } catch {
      // nvidia-smi not available (e.g. non-NVIDIA machine or server deployment)
    }

    const used = usedRaw ? parseFloat(usedRaw) : 0;
    const total = totalRaw ? parseFloat(totalRaw) : 16311; // fallback to 16GB
    const usedGB = (used / 1024).toFixed(1);
    const totalGB = (total / 1024).toFixed(1);
    const vramPercent = total > 0 ? Math.round((used / total) * 100) : 0;

    // Check service ports
    const servicesToCheck = [
      { key: 'devApp',    port: 3000 },
      { key: 'taskBoard', port: 3001 },
      { key: 'workspace', port: 3005 },
      { key: 'dashboard', port: 9119 },
      { key: 'comfyUI',   port: 8188 },
      { key: 'postiz',    port: 4007 }
    ];

    const serviceResults: Record<string, boolean> = {};
    let allNominal = true;

    for (const s of servicesToCheck) {
      const active = await checkPort(s.port);
      serviceResults[s.key] = active;
      if (!active) {
        // If critical system components are down, mark nominal as false
        allNominal = false;
      }
    }

    return NextResponse.json({
      used: usedGB,
      total: totalGB,
      percent: vramPercent,
      services: serviceResults,
      allNominal: allNominal,
      status: 'success'
    });
  } catch (error: unknown) {
    const errMsg = error instanceof Error ? error.message : String(error);
    return NextResponse.json({
      used: '0.0',
      total: '16.0',
      percent: 0,
      services: {},
      allNominal: false,
      status: 'error',
      message: errMsg
    });
  }
}
