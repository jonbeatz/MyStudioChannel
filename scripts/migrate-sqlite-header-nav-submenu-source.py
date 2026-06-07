"""
Add `submenu_source` to `header_nav_items` for Payload field `submenuSource` (`db.push: false`).

Sets `pages-collection` on legacy rows labeled `Pages`, then renames that row to `Legal`.

Run: python scripts/migrate-sqlite-header-nav-submenu-source.py
"""

from __future__ import annotations

import sqlite3
from pathlib import Path

DB = Path(__file__).resolve().parents[1] / "payload.sqlite"
TABLE = "header_nav_items"
COL = "submenu_source"
DEFAULT = "manual"
LEGACY_VALUE = "pages-collection"


def existing_columns(conn: sqlite3.Connection, table: str) -> set[str]:
    rows = conn.execute(f'PRAGMA table_info("{table}")').fetchall()
    return {r[1] for r in rows}


def main() -> None:
    if not DB.is_file():
        raise SystemExit(f"Missing database: {DB}")

    conn = sqlite3.connect(DB)
    try:
        tables = {
            r[0]
            for r in conn.execute(
                "SELECT name FROM sqlite_master WHERE type='table'"
            ).fetchall()
        }
        if TABLE not in tables:
            raise SystemExit(
                f'Table "{TABLE}" not found. Available: {sorted(tables)!r}'
            )

        cols = existing_columns(conn, TABLE)
        if COL not in cols:
            conn.execute(
                f'ALTER TABLE "{TABLE}" ADD COLUMN "{COL}" TEXT DEFAULT \'{DEFAULT}\''
            )
            print(f'Added "{TABLE}"."{COL}" TEXT DEFAULT {DEFAULT!r}')
        else:
            print(f'Column "{COL}" already present; skipping ALTER.')

        updated = conn.execute(
            f'''
            UPDATE "{TABLE}"
            SET "{COL}" = ?
            WHERE trim("label") = 'Pages'
              AND ("{COL}" IS NULL OR trim("{COL}") = '' OR "{COL}" = ?)
            ''',
            (LEGACY_VALUE, DEFAULT),
        ).rowcount
        conn.commit()
        print(
            f'Updated {updated} row(s) with label "Pages" to submenu_source = {LEGACY_VALUE!r}.'
        )

        renamed = conn.execute(
            f'''
            UPDATE "{TABLE}"
            SET "label" = 'Legal'
            WHERE trim("label") = 'Pages' AND "{COL}" = ?
            ''',
            (LEGACY_VALUE,),
        ).rowcount
        conn.commit()
        print(f'Renamed {renamed} row(s) from label "Pages" to "Legal".')
    finally:
        conn.close()


if __name__ == "__main__":
    main()
