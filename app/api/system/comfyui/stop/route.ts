import { NextResponse } from 'next/server';
import { execFile } from 'child_process';
import { promisify } from 'util';
import path from 'path';

const execFileAsync = promisify(execFile);

type StopBody = {
  dryRun?: boolean;
  force?: boolean;
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

  let body: StopBody = {};
  try {
    body = (await request.json()) as StopBody;
  } catch {
    body = {};
  }

  const scriptPath = path.join(
    process.cwd(),
    '.cursor',
    'custom-scriptz',
    'stop-comfyui.ps1',
  );

  const args = ['-ExecutionPolicy', 'Bypass', '-NoProfile', '-File', scriptPath, '-Json'];
  if (body.dryRun) args.push('-DryRun');
  if (body.force) args.push('-Force');

  try {
    const { stdout, stderr } = await execFileAsync('powershell', args, {
      timeout: 60000,
      maxBuffer: 1024 * 512,
    });

    let result: Record<string, unknown> = { status: 'stopped', output: stdout };
    try {
      result = { ...result, ...(JSON.parse(stdout.trim()) as Record<string, unknown>) };
    } catch {
      /* stdout may include Write-Host lines before JSON */
    }

    return NextResponse.json({
      ...result,
      stderr: stderr || undefined,
    });
  } catch (error: unknown) {
    const errMsg = error instanceof Error ? error.message : String(error);
    return NextResponse.json({ status: 'error', message: errMsg }, { status: 500 });
  }
}
