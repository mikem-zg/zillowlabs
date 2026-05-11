---
name: sprint-review-summary
description: >
  Generates a formatted Slack post summarizing a ZHL OER sprint review/demo meeting from a Zoom recording.
  The output follows the exact team-by-team bullet format used in the ZHL OER Slack channel, with presenter
  Slack handles, video timestamps, and one-line descriptions per demo. Optionally validates the summary
  against a provided slide deck.

  Use this skill whenever the user wants to: summarize a sprint review or sprint demo meeting, generate a
  Slack post from a Zoom recording, create a "what was demoed" digest, turn a sprint review recording into
  a shareable summary, or post sprint highlights to Slack. Also use it when the user pastes a Zoom recording
  link and mentions sprint, demo, OER, ZAAP, LIGHTHOUSE, NEXUS, IOE, IRIS, or FUSE.
---

# Sprint Review Summary Skill

Produces the formatted ZHL OER Slack sprint-review post from a Zoom recording transcript. Output looks exactly like the example in `references/output-format.md` — read that file first to internalize the format before producing any output.

## Step 0 — Read the format reference

Before generating anything, read `references/output-format.md`. This tells you the exact template, a real example, and all formatting rules. Do not proceed until you've read it.

---

## Step 1 — Identify the meeting

**From a Zoom recording URL**: Extract the meeting_id from the URL's `meeting_id=` parameter (URL-decode it). Example:
- URL: `https://zillowgroup.zoom.us/recording/detail?meeting_id=fXTfk%2Fk3S2Wcuqo4BMqIVA%3D%3D`
- Decoded meeting_id: `fXTfk/k3S2Wcuqo4BMqIVA==`

**From a meeting title or "most recent sprint review"**: Use `search_meetings` with `q="ZHL OER Sprint Review"` and an appropriate date range.

The key output you need from this step: the `meeting_uuid` (e.g. `CF2E14D2-0E72-4417-B618-200750572332`) — prefer UUID over numeric meeting ID because it targets a specific occurrence.

---

## Step 2 — Fetch the transcript

Call `get_meeting_assets` with the `meetingId` set to the meeting UUID. The response contains:
- `recording.transcripts[0].timeline` — an array of timestamped utterances: `{display_name, ts, end_ts, text}`
  - `ts` format: `"00:02:39.710"` → convert to `MM:SS` as `02:39`
- `recording.summaries[0]` — AI chapter summaries (use as a cross-reference, not as the primary source)
- `recording.play_url` — the recording link to include in the post header

**IMPORTANT**: The transcript response is large (~160K characters). It will be saved to a file rather than returned inline. Use a bash script to parse it:

```bash
# Extract and format the transcript timeline as readable text
python3 - <<'EOF'
import json, sys

with open('<path-to-tool-result-file>') as f:
    data = json.load(f)

timeline = data['recording']['transcripts'][0]['timeline']
for item in timeline:
    ts = item['ts']  # "00:02:39.710" -> "02:39"
    parts = ts.split(':')
    mm_ss = f"{int(parts[1]):02d}:{int(float(parts[2])):02d}"
    print(f"[{mm_ss}] {item['display_name']}: {item['text']}")
EOF
```

Also extract chapter summaries for reference:
```bash
python3 -c "
import json
with open('<path>') as f: d = json.load(f)
for item in d['recording']['summaries'][0]['items']:
    ts = item['start_time']
    parts = ts.split(':')
    mm_ss = f\"{int(parts[1]):02d}:{int(float(parts[2])):02d}\"
    print(f\"[{mm_ss}] {item['label']}: {item['summary'][:200]}\")
"
```

---

## Step 3 — Parse the transcript into team sections

Read through the formatted transcript and identify:

**Team boundaries**: Femi (or the meeting host) introduces each team by name. Look for phrases like "I'll pass it on to [name]", "Next up is [team]", "over to [team]". The team order is ZAAP → LIGHTHOUSE → NEXUS → IOE → IRIS → FUSE.

**Individual demos within each team**: Each team lead gives a brief overview, then individual presenters demo specific items. Identify:
- The **topic title**: what was demoed (2–5 words, noun phrase)
- The **presenters**: who spoke during that demo
- The **start timestamp**: the `MM:SS` of when that demo begins (usually when the presenter starts their screen share or says "I'll show you...")
- The **one-line description**: what was built/shown, written as a tight action phrase (see examples in `references/output-format.md`)

**Tips for identifying demo boundaries**:
- New demos typically start with "So today I'm going to show...", "This sprint we worked on...", or the audio/screen share label changes
- Team leads often enumerate their demos at the start ("We have three things to show you...") — use this as a guide to how many bullets a team should have
- The AI chapter summaries are a useful cross-check but may group multiple demos into one chapter — always use the raw transcript as ground truth for timestamps and what was actually shown

---

## Step 4 — Look up Slack handles

For each unique presenter, look up their Slack handle using `slack_search_users` with their full name.

```
slack_search_users(query="Ashley Zhu")
→ look at username or display name field for the @handle
```

The handle to use is the user's Slack display name or username (without the @). If a user can't be found, use their first name only or a reasonable approximation based on the pattern `firstnamelastinitial` (e.g., "Francisco Betancourt" → `franciscobet`).

Build a mapping: `{display_name_in_zoom: slack_handle}` before generating output.

---

## Step 5 — Generate the Slack post

Using the format from `references/output-format.md`, assemble the post:

1. **Header**: `ZHL OER Sprint Review – [date]. Jump to what's most relevant to you: 👇`
   - Date: derive from the meeting's `start_time` field, format as M/D/YY (e.g. `4/21/26`)
2. **Links line**: `Zoom: [play_url] | Passcode: [passcode] | Deck: [slides_url]`
   - Omit Passcode if not available
   - Omit Deck if no slides URL was provided
3. **Team sections**: For each team that presented, one blank line then the team name in ALL CAPS, then bullets
4. **Bullets**: `• [Title] (@handle1, @handle2 / MM:SS) – [Description.]`

Write the output clearly so the user can copy-paste it directly into Slack. If producing a file, save it as a `.txt` or `.md` file in the workspace folder.

---

## Step 6 — Validate against slide deck (if provided)

If the user provided a Google Slides URL, use the Chrome browser tools to read the slides and validate the summary:

```
navigate to [slides_url]
read_page / get_page_text  ← read the slide content
```

Then compare each bullet in the generated summary against the slides:
- Does every demo in the slides appear in the summary? If not, flag as **missed**.
- Does every bullet in the summary appear on a slide? If not, flag as **transcript-only** (still valid — presenters sometimes go off-script).
- Are the topic titles consistent with the slide headings? Adjust if the slide title is clearer.

Report any discrepancies clearly before presenting the final output. If validation finds missed items, add them to the summary.

---

## Step 7 — Present the output

Show the user the formatted Slack post in a code block so it's easy to copy. Also note:
- Any Slack handles you weren't able to confirm (so the user can check them)
- Any validation discrepancies found in Step 6
- Optionally save as a file to the workspace folder

---

## Error handling

- **No transcript available** (`has_transcript: false`): The recording may still be processing, or transcript permissions may not be granted. Try `get_recording_resource` with `types="transcript"` and the passcode if known. If still unavailable, use the AI summary from `recording.summaries` as a fallback — note in the output that it's summary-based.
- **Meeting not found**: Try `search_meetings` with broader date range or slightly different topic keywords.
- **Slides not accessible**: Note in output that slide validation was skipped and the user should verify manually.
- **Large transcript file**: Always use Python/bash to parse rather than reading raw JSON inline.