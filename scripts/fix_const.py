#!/usr/bin/env python3
"""Remove 'const' from widget calls that now contain .tr() expressions."""
import re
from pathlib import Path

def is_ui_file(p):
    s = p.as_posix()
    if any(k in s for k in ['/data/', '/manager/', '/model/', '/repo/']):
        return False
    if any(k in p.name for k in ['cubit.dart', 'state.dart', 'bloc.dart']):
        return False
    return any(k in s for k in ['/ui/', '/screens/', '/widgets/', 'bottom_nav_bar', 'splash', 'auth'])

# Constructors that might wrap .tr() calls and can't be const
WIDGET_CTORS = [
    'Text', 'InputDecoration', 'OutlineInputBorder', 'UnderlineInputBorder',
    'AlertDialog', 'SnackBar', 'Row', 'Column', 'Padding', 'Center',
    'Container', 'SizedBox', 'ElevatedButton', 'TextButton', 'IconButton',
    'ListTile', 'Card', 'Scaffold', 'AppBar', 'BottomNavigationBarItem',
    'Tab', 'DropdownMenuItem',
]

# Build a pattern that removes `const` before any of these when the line has .tr()
CTOR_PAT = re.compile(
    r'\bconst\s+(' + '|'.join(re.escape(c) for c in WIDGET_CTORS) + r')\('
)

def fix_content(content: str) -> str:
    lines = content.split('\n')
    new_lines = []
    for line in lines:
        if '.tr()' in line:
            line = CTOR_PAT.sub(r'\1(', line)
        new_lines.append(line)
    return '\n'.join(new_lines)

ui_files = [p for p in Path('lib').rglob('*.dart') if is_ui_file(p)]
changed = 0

for fpath in ui_files:
    try:
        original = fpath.read_text(encoding='utf-8', errors='ignore')
    except Exception:
        continue

    if '.tr()' not in original:
        continue

    updated = fix_content(original)
    if updated != original:
        fpath.write_text(updated, encoding='utf-8')
        changed += 1

print(f"Fixed const in {changed} files.")
