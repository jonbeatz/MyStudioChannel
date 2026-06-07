import { getPayload } from 'payload';
import config from '@/payload.config';
import fs from 'node:fs';
import path from 'node:path';
import { NextResponse } from 'next/server';

const SEED_DATA_DIR = path.join(process.cwd(), 'seed-data');

/**
 * MSC DEV LAB - Seeding API
 * Isolated endpoint for content migration in development.
 * Disabled in production.
 */

export async function GET() {
  if (process.env.NODE_ENV !== 'development') {
    return new Response('Not Found', { status: 404 });
  }

  const payload = await getPayload({ config });
  
  if (!fs.existsSync(SEED_DATA_DIR)) {
    fs.mkdirSync(SEED_DATA_DIR);
  }

  const collections = ['pages', 'media'];
  const globals = ['homepage', 'header', 'site-settings', 'projects-home'];
  const logs: string[] = [];

  try {
    for (const collection of collections) {
      const result = await payload.find({
        collection,
        limit: 0,
        depth: 0,
        pagination: false,
      });
      const sanitized = result.docs.map((doc: { createdAt?: string; updatedAt?: string; [key: string]: unknown }) => {
        // eslint-disable-next-line @typescript-eslint/no-unused-vars
        const { createdAt, updatedAt, ...rest } = doc;
        return rest;
      });
      fs.writeFileSync(path.join(SEED_DATA_DIR, `${collection}.json`), JSON.stringify(sanitized, null, 2));
      logs.push(`Exported ${collection} (${sanitized.length} docs)`);
    }

    for (const slug of globals) {
      const doc = await payload.findGlobal({ slug, depth: 0 }) as { createdAt?: string; updatedAt?: string; [key: string]: unknown };
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const { createdAt, updatedAt, ...rest } = doc;
      fs.writeFileSync(path.join(SEED_DATA_DIR, `${slug}.json`), JSON.stringify(rest, null, 2));
      logs.push(`Exported global: ${slug}`);
    }

    return NextResponse.json({ success: true, logs });
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    return NextResponse.json({ success: false, error: message }, { status: 500 });
  }
}

export async function POST() {
  if (process.env.NODE_ENV !== 'development') {
    return new Response('Not Found', { status: 404 });
  }

  const payload = await getPayload({ config });
  const logs: string[] = [];

  if (!fs.existsSync(SEED_DATA_DIR)) {
    return NextResponse.json({ success: false, error: 'seed-data/ folder missing' }, { status: 400 });
  }

  try {
    const collections = ['media', 'pages']; // media first for relationships
    const globals = ['homepage', 'header', 'site-settings', 'projects-home'];

    for (const collection of collections) {
      const filePath = path.join(SEED_DATA_DIR, `${collection}.json`);
      if (!fs.existsSync(filePath)) continue;

      const docs = JSON.parse(fs.readFileSync(filePath, 'utf8'));
      for (const doc of docs) {
        const where = doc.slug ? { slug: { equals: doc.slug } } : { id: { equals: doc.id } };
        const existing = await payload.find({ collection, where, limit: 1, depth: 0 });

        if (existing.docs.length > 0) {
          await payload.update({ collection, id: existing.docs[0].id, data: doc });
          logs.push(`Updated ${collection}: ${doc.slug || doc.id}`);
        } else {
          await payload.create({ collection, data: doc });
          logs.push(`Created ${collection}: ${doc.slug || doc.id}`);
        }
      }
    }

    for (const slug of globals) {
      const filePath = path.join(SEED_DATA_DIR, `${slug}.json`);
      if (!fs.existsSync(filePath)) continue;

      const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
      await payload.updateGlobal({ slug, data });
      logs.push(`Updated global: ${slug}`);
    }

    return NextResponse.json({ success: true, logs });
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    return NextResponse.json({ success: false, error: message }, { status: 500 });
  }
}
