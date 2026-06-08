import { NextResponse } from 'next/server';
import { notFound } from 'next/navigation';
import * as Sentry from '@sentry/nextjs';

export async function GET() {
  if (process.env.NODE_ENV === 'production') {
    notFound();
  }
  try {
    // Generate an isolated transaction span inside Sentry
    return Sentry.withActiveSpan(null, () => {
      throw new Error("Simulated Server-Side Exception from MyStudioChannel Dev Playground API!");
    });
  } catch (error) {
    // Explicitly capture and report to Sentry
    Sentry.captureException(error);
    
    const errorMessage = error instanceof Error ? error.message : "Unknown error";
    
    return NextResponse.json(
      { 
        status: 'error', 
        message: 'Simulated exception triggered and reported successfully to Sentry!',
        details: errorMessage
      },
      { status: 500 }
    );
  }
}

