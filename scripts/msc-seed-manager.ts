/**
 * MSC PRO ENGINE - Seed Manager CLI
 * Triggers the internal seeding API route.
 * 
 * Usage:
 *   npm run seed:production  (Exports current DB to seed-data/)
 *   npm run seed:all         (Imports from seed-data/ to DB)
 */

const PORT = process.env.PORT || 3000;
const BASE_URL = `http://127.0.0.1:${PORT}/api/dev/seed`;

const BANNER_EXPORT = '\x1b[1m\x1b[35m[msc:seed:export]\x1b[0m';
const BANNER_IMPORT = '\x1b[1m\x1b[36m[msc:seed:import]\x1b[0m';

async function main() {
  const isExport = process.argv.includes('--export');
  const banner = isExport ? BANNER_EXPORT : BANNER_IMPORT;
  const method = isExport ? 'GET' : 'POST';

  console.log(`${banner} Triggering Dev Lab API (${method})...`);

  try {
    const response = await fetch(BASE_URL, { 
      method,
      headers: { 'Content-Type': 'application/json' }
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`API returned ${response.status}: ${errorText}`);
    }

    const result = await response.json();
    
    if (result.success) {
      result.logs.forEach((log: string) => console.log(`   ${log}`));
      console.log(`\n✅ ${banner} Operation complete!`);
    } else {
      console.error(`\n❌ ${banner} Failed:`, result.error);
    }
  } catch (err: any) {
    console.error(`\n❌ ${banner} Error:`, err.message);
    console.error(`   Ensure the dev server is running on port ${PORT}.`);
    process.exit(1);
  }
}

main();
