with open('lib/features/booking_user/ui/widgets/booking_card.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
depth = 0
in_string = False
string_char = None
escape_next = False

for i, line in enumerate(lines):
    lineno = i + 1
    for j, ch in enumerate(line):
        if escape_next:
            escape_next = False
            continue
        if in_string:
            if ch == '\\':
                escape_next = True
            elif ch == string_char:
                in_string = False
        else:
            if ch in ('"', "'"):
                in_string = True
                string_char = ch
            elif ch in ('(', '[', '{'):
                depth += 1
            elif ch in (')', ']', '}'):
                depth -= 1

    if lineno >= 100 and lineno <= 115:
        print(f"Line {lineno} depth={depth}: {repr(line[:70])}")
