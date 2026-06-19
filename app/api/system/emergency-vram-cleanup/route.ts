import { NextResponse } from 'next/server';
import { execFile } from 'child_process';
import { promisify } from 'util';
import path from 'path';

const execFileAsync = promisify(execFile);

export async function POST() {
  if (process.env.NODE_ENV === 'production' && process.env.VERCEL === '1') {
    return NextResponse.json(
      { status: 'disabled', message: 'Emergency cleanup is localhost-only.' },
      { status: 403 },
    );
  }

  if (process.platform !== 'win32') {
    return NextResponse.json(
      { status: 'unsupported', message: 'Windows workstation only.' },
      { status: 400 },
    );
  }

  const scriptPath = path.join(
    process.cwd(),
    '.cursor',
    'custom-scriptz',
    'vram-cleanup.ps1',
  );

  try {
    const { stdout, stderr } = await execFileAsync(
      'powershell',
      ['-ExecutionPolicy', 'Bypass', '-NoProfile', '-File', scriptPath],
      { timeout: 60000, maxBuffer: 1024 * 512 },
    );

    return NextResponse.json({
      status: 'cleanup-complete',
      output: stdout,
      stderr: stderr || undefined,
    });
  } catch (error: unknown) {
    const errMsg = error instanceof Error ? error.message : String(error);
    return NextResponse.json(
      { status: 'error', message: errMsg },
      { status: 500 },
    );
  }
}
