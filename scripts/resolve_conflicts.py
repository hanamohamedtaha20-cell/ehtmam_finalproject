#!/usr/bin/env python3
"""Resolve all git conflict markers by accepting the incoming (theirs) side."""
import subprocess, sys
from pathlib import Path

def get_conflict_files():
    r = subprocess.run(['git', 'diff', '--name-only', '--diff-filter=U'],
                       capture_output=True, text=True)
    return [f.strip() for f in r.stdout.splitlines() if f.strip()]

def accept_theirs(content: str) -> str:
    """Remove <<<HEAD...====== blocks, keep ======...>>> blocks."""
    lines = content.split('\n')
    result = []
    state = 'normal'  # 'normal' | 'ours' | 'theirs'
    for line in lines:
        if line.startswith('<<<<<<< '):
            state = 'ours'
        elif line == '=======' and state == 'ours':
            state = 'theirs'
        elif line.startswith('>>>>>>> ') and state == 'theirs':
            state = 'normal'
        else:
            if state != 'ours':  # keep normal + theirs, skip ours
                result.append(line)
    return '\n'.join(result)

files = get_conflict_files()
print(f'Found {len(files)} conflicted files')

for rel in files:
    p = Path(rel)
    if not p.exists():
        print(f'  SKIP (not found): {rel}')
        continue
    original = p.read_text(encoding='utf-8', errors='replace')
    if '<<<<<<<' not in original:
        print(f'  SKIP (no markers): {rel}')
        continue
    resolved = accept_theirs(original)
    p.write_text(resolved, encoding='utf-8')
    print(f'  Resolved: {rel}')

print('\nStaging resolved files...')
subprocess.run(['git', 'add', '--'] + files, check=True)
print('All conflicts resolved and staged.')
print('\nRun: git rebase --continue')
