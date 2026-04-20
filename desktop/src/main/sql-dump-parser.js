// Parses tables from a PostgreSQL pg_dump unpacked SQL file (text format,
// `COPY ... FROM stdin;` blocks). Returns an object of arrays of row objects
// keyed by table name.
//
// Supports the PG COPY escape conventions:
//   \N  → null  (field-level; never inline)
//   \\  → \
//   \t  → tab
//   \n  → newline
//   \r  → carriage return
//   \b  → backspace
//   \f  → form feed
//   \v  → vertical tab
// Other escapes are passed through.

function unescapeCopyValue(s) {
  if (s === '\\N') return null;
  let out = '';
  for (let i = 0; i < s.length; i++) {
    const c = s[i];
    if (c === '\\' && i + 1 < s.length) {
      const next = s[i + 1];
      switch (next) {
        case '\\': out += '\\'; i++; break;
        case 't': out += '\t'; i++; break;
        case 'n': out += '\n'; i++; break;
        case 'r': out += '\r'; i++; break;
        case 'b': out += '\b'; i++; break;
        case 'f': out += '\f'; i++; break;
        case 'v': out += '\v'; i++; break;
        default: out += c; break;
      }
    } else {
      out += c;
    }
  }
  return out;
}

// Parses a COPY block header line, returning the column list.
//   COPY "public"."spheres" ("id", "panorama", ...) FROM stdin;
function parseCopyHeader(line) {
  const m = line.match(/^COPY\s+"?public"?\."?(\w+)"?\s*\(([^)]*)\)\s+FROM\s+stdin;\s*$/i);
  if (!m) return null;
  const table = m[1];
  const cols = m[2].split(',').map(c => c.trim().replace(/^"(.+)"$/, '$1'));
  return { table, cols };
}

// Parses the entire SQL dump text and returns { tableName: [rowObject, ...] }
// for the requested tables. Tables not present in the dump are returned as [].
function parseDump(sqlText, wantedTables) {
  const result = {};
  for (const t of wantedTables) result[t] = [];

  const lines = sqlText.split('\n');
  let i = 0;
  while (i < lines.length) {
    const header = parseCopyHeader(lines[i]);
    if (!header) { i++; continue; }

    const { table, cols } = header;
    const capture = wantedTables.includes(table);
    i++; // move past header

    // Consume rows until the terminator `\.` on its own line
    while (i < lines.length && lines[i] !== '\\.') {
      if (capture) {
        const rawFields = lines[i].split('\t');
        if (rawFields.length === cols.length) {
          const row = {};
          for (let k = 0; k < cols.length; k++) {
            row[cols[k]] = unescapeCopyValue(rawFields[k]);
          }
          result[table].push(row);
        }
      }
      i++;
    }
    i++; // skip the terminator
  }
  return result;
}

// Converts the YAML-serialized polygon_px field stored by Rails into an array
// of [x, y] pairs. Rails serializes a Ruby Array<Array<Integer>> as:
//   ---
//   - - 4971
//     - 1957
//   - - 5446
//     - 1789
// Each "- - N" line opens a new pair with N as the first element; the following
// indented "  - M" line supplies the second element. Returns [] for null/empty.
function parsePolygonYaml(value) {
  if (!value) return [];
  const pairs = [];
  let current = null;
  // Flat fallback: older rows serialized a flat Array<Integer> as
  //   ---
  //   - 4042
  //   - 289
  //   - 4402
  // Pair those numbers up.
  const flatNums = [];
  for (const line of value.split('\n')) {
    const openPair = line.match(/^-\s+-\s+(-?\d+(?:\.\d+)?)\s*$/);
    if (openPair) {
      if (current && current.length === 2) pairs.push(current);
      current = [parseFloat(openPair[1])];
      continue;
    }
    const continuePair = line.match(/^\s+-\s+(-?\d+(?:\.\d+)?)\s*$/);
    if (continuePair && current && current.length < 2) {
      current.push(parseFloat(continuePair[1]));
      continue;
    }
    const flat = line.match(/^-\s+(-?\d+(?:\.\d+)?)\s*$/);
    if (flat) flatNums.push(parseFloat(flat[1]));
  }
  if (current && current.length === 2) pairs.push(current);
  if (pairs.length) return pairs;
  for (let i = 0; i + 1 < flatNums.length; i += 2) pairs.push([flatNums[i], flatNums[i + 1]]);
  return pairs;
}

module.exports = { parseDump, parsePolygonYaml, unescapeCopyValue };
