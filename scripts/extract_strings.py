"""
Phase 1: Extract all hardcoded static UI strings from Flutter UI files.
Handles Text('...'), Text("..."), hintText, labelText, tooltip, title in AppBar, etc.
"""
import os, re, json
from pathlib import Path

ROOT = Path(__file__).parent.parent / 'lib'

# --- helpers ---

def is_ui_file(p: Path) -> bool:
    s = p.as_posix()
    if any(k in s for k in ['/data/', '/manager/', '/model/', '/repo/']):
        return False
    if any(k in p.name for k in ['cubit.dart', 'state.dart', 'bloc.dart']):
        return False
    return any(k in s for k in [
        '/ui/', '/screens/', '/widgets/',
        'bottom_nav_bar', 'splash', 'auth',
    ])


def to_key(text: str) -> str:
    """Convert English UI string → snake_case translation key."""
    t = text.lower().strip()
    t = re.sub(r'[?!:\.]+$', '', t)
    t = re.sub(r'[^a-z0-9]+', '_', t)
    t = t.strip('_')
    parts = t.split('_')
    if len(parts) > 7:
        t = '_'.join(parts[:7])
    return t or 'text'


def is_skip(s: str) -> bool:
    if not s or len(s) < 2:
        return True
    if s.endswith('.tr()'):
        return True
    if '$' in s or '{' in s:
        return True
    if re.fullmatch(r'[\d\s\.\-\+\:\/\,\—\–]+', s):
        return True
    if s.startswith('http') or '://' in s:
        return True
    if s.startswith('assets/') or s.endswith('.png') or s.endswith('.svg'):
        return True
    if re.fullmatch(r'[\W_]+', s):
        return True
    # Version strings, package names
    if re.fullmatch(r'[a-z0-9_\.]+', s) and '.' in s and ' ' not in s:
        return True
    return False


def extract_strings(content: str) -> list[str]:
    """Find all static string literals that appear as UI text."""
    results = []
    seen = set()

    def add(s: str):
        s = s.strip()
        if not is_skip(s) and s not in seen:
            seen.add(s)
            results.append(s)

    # 1. Text('...') or Text("...") — with optional extra args like style:
    #    Match: Text(\n  '...',\n  style...
    for pat in [
        re.compile(r"""Text\(\s*'([^'$\n]{2,})'\s*[,\)]"""),
        re.compile(r'''Text\(\s*"([^"$\n]{2,})"\s*[,\)]'''),
    ]:
        for m in pat.finditer(content):
            add(m.group(1))

    # 2. hintText: '...', labelText: '...', helperText: '...', errorText: '...'
    for pat in [
        re.compile(r"""(?:hintText|labelText|helperText|errorText|counterText|prefixText|suffixText)\s*:\s*'([^'$\n]+)'"""),
        re.compile(r'''(?:hintText|labelText|helperText|errorText|counterText|prefixText|suffixText)\s*:\s*"([^"$\n]+)"'''),
    ]:
        for m in pat.finditer(content):
            add(m.group(1))

    # 3. tooltip: '...'
    for pat in [
        re.compile(r"""tooltip\s*:\s*'([^'$\n]+)'"""),
        re.compile(r'''tooltip\s*:\s*"([^"$\n]+)"'''),
    ]:
        for m in pat.finditer(content):
            add(m.group(1))

    # 4. title: '...' inside AppBar (raw string, not Text widget)
    for pat in [
        re.compile(r"""(?:title|message|label)\s*:\s*'([A-Z][^'$\n]{2,})'"""),
        re.compile(r'''(?:title|message|label)\s*:\s*"([A-Z][^"$\n]{2,})"'''),
    ]:
        for m in pat.finditer(content):
            s = m.group(1)
            if not any(c in s for c in ['(', ')', '.', '/']):
                add(s)

    # 5. SnackBar content: Text('...')  — already caught above
    # 6. showSnackBar message strings
    for pat in [
        re.compile(r"""SnackBar\s*\(\s*content\s*:\s*(?:const\s+)?Text\s*\(\s*'([^'$\n]+)'"""),
        re.compile(r'''SnackBar\s*\(\s*content\s*:\s*(?:const\s+)?Text\s*\(\s*"([^"$\n]+)"'''),
    ]:
        for m in pat.finditer(content):
            add(m.group(1))

    # 7. subtitle / title in ListTile / BottomNavBar etc. passed as raw strings
    for pat in [
        re.compile(r"""(?:subtitle|label)\s*:\s*const\s+Text\s*\(\s*'([^'$\n]+)'"""),
        re.compile(r'''(?:subtitle|label)\s*:\s*const\s+Text\s*\(\s*"([^"$\n]+)"'''),
    ]:
        for m in pat.finditer(content):
            add(m.group(1))

    return results


# --- main ---

ui_files = [p for p in ROOT.rglob('*.dart') if is_ui_file(p)]
print(f"Scanning {len(ui_files)} UI files ...")

all_strings: dict[str, set] = {}   # string -> set of files

for fpath in ui_files:
    try:
        content = fpath.read_text(encoding='utf-8', errors='ignore')
    except Exception:
        continue
    for s in extract_strings(content):
        all_strings.setdefault(s, set()).add(fpath.as_posix())

print(f"Unique static strings found: {len(all_strings)}\n")

by_freq = sorted(all_strings.items(), key=lambda x: -len(x[1]))
for s, files in by_freq:
    print(f"  {len(files):3d}x  {repr(s[:80])}")

out_path = Path(__file__).parent / 'found_strings.json'
json.dump(
    {s: sorted(files) for s, files in all_strings.items()},
    out_path.open('w', encoding='utf-8'),
    ensure_ascii=False,
    indent=2,
)
print(f"\nSaved to {out_path}")
