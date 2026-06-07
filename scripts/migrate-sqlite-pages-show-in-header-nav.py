"""
Add `show_in_header_nav` to `pages` for Payload field `showInHeaderNav` (`db.push: false`).

Run: python scripts/migrate-sqlite-pages-show-in-header-nav.py
"""

from __future__ import annotations

import sqlite3
from pathlib import Path

DB = Path(__file__).resolve().parents[1] / "payload.sqlite"
TABLE = "pages"
COL = "show_in_header_nav"


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
            raise SystemExit(f'Table "{TABLE}" not found.')

        cols = existing_columns(conn, TABLE)
        if COL not in cols:
            conn.execute(
                f'ALTER TABLE "{TABLE}" ADD COLUMN "{COL}" INTEGER DEFAULT 1'
            )
            print(f'Added column {TABLE}.{COL} (default 1).')
        else:
            print(f"Column {COL!r} already present.")

        conn.execute(
            f'UPDATE "{TABLE}" SET "{COL}" = 0 WHERE lower(slug) = ?',
            ("msc1",),
        )
        conn.commit()
        print('Set show_in_header_nav = 0 for slug "msc1".')
    finally:
        conn.close()


if __name__ == "__main__":
    main()
