import { NextResponse } from 'next/server';
import { execFile } from 'child_process';
import { promisify } from 'util';
import path from 'path';

const execFileAsync = promisify(execFile);

type RestartBody = {
  force?: boolean;
  noVramCheck?: boolean;
  lowVram?: boolean;
  unloadLmStudio?: boolean;
};

function localhostOnly() {
  if (process.env.NODE_ENV === 'production' && process.env.VERCEL === '1') {
    return NextResponse.json(
      { status: 'disabled', message: 'ComfyUI control is localhost-only.' },
      { status: 403 },
    );
  }
  if (process.platform !== 'win32') {
    return NextResponse.json(
      { status: 'unsupported', message: 'Windows workstation only.' },
      { status: 400 },
    );
  }
  return null;
}

export async function POST(request: Request) {
  const blocked = localhostOnly();
  if (blocked) return blocked;

  let body: RestartBody = {};
  try {
    body = (await request.json()) as RestartBody;
  } catch {
    body = {};
  }

  const scriptPath = path.join(
    process.cwd(),
    '.cursor',
    'custom-scriptz',
    'restart-comfyui.ps1',
  );

  const args = ['-ExecutionPolicy', 'Bypass', '-NoProfile', '-File', scriptPath];
  if (body.force) args.push('-Force');
  if (body.noVramCheck) args.push('-NoVRAMCheck');
  if (body.lowVram) args.push('-LowVram');
  if (body.unloadLmStudio) args.push('-UnloadLMStudio');

  try {
    const { stdout, stderr } = await execFileAsync('powershell', args, {
      timeout: 180000,
      maxBuffer: 1024 * 512,
    });

    return NextResponse.json({
      status: 'restarted',
      output: stdout,
      stderr: stderr || undefined,
    });
  } catch (error: unknown) {
    const errMsg = error instanceof Error ? error.message : String(error);
    return NextResponse.json({ status: 'error', message: errMsg }, { status: 500 });
  }
}
