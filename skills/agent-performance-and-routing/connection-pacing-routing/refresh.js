#!/usr/bin/env node

const SKILL_FILE = __dirname + "/SKILL.md";
const SOURCE_URL =
  "https://gitlab.zgtools.net/zillow/conductors/services/connection-pacing/-/blob/main/CLAUDE.md";

async function main() {
  const fs = require("fs");

  if (typeof mcpGlean_readDocument === "undefined") {
    console.error(
      "ERROR: mcpGlean_readDocument is not available.\n" +
        "This script must be run from the Replit agent code_execution sandbox\n" +
        "where Glean MCP callbacks are pre-registered.\n\n" +
        "Ask the agent: 'Refresh the connection-pacing-routing skill'"
    );
    process.exit(1);
  }

  console.log("Fetching CLAUDE.md from:", SOURCE_URL);
  const result = await mcpGlean_readDocument({ urls: [SOURCE_URL] });

  if (result.status !== "success" || !result.content || !result.content.length) {
    console.error("ERROR: Failed to fetch document from Glean.");
    console.error(JSON.stringify(result, null, 2));
    process.exit(1);
  }

  var rawContent;
  try {
    var parsed = JSON.parse(result.content[0].text);
    rawContent =
      parsed.documents &&
      parsed.documents[0] &&
      parsed.documents[0].snippets &&
      parsed.documents[0].snippets[0];
  } catch (e) {
    var text = result.content[0] && (result.content[0].text || result.content[0]);
    if (typeof text === "string" && text.length > 100) {
      rawContent = text;
    }
  }

  if (!rawContent) {
    console.error("ERROR: No document content found in Glean response.");
    console.error("Response shape:", JSON.stringify(Object.keys(result), null, 2));
    process.exit(1);
  }

  console.log("Fetched content length:", rawContent.length, "chars");

  const today = new Date().toISOString().split("T")[0];

  const skillContent = buildSkillMd(rawContent, today);

  fs.writeFileSync(SKILL_FILE, skillContent, "utf8");
  console.log("SKILL.md updated successfully (" + skillContent.length + " chars)");
  console.log("Last refreshed:", today);
}

function buildSkillMd(raw, date) {
  var lines = [];
  lines.push("---");
  lines.push("name: connection-pacing-routing");
  lines.push("description: >-");
  lines.push("  Implementation-level documentation for the connection-pacing service (ALR/BAT routing,");
  lines.push("  PaceCar V3 scoring, handler priority chain, API clients, data models). Use when");
  lines.push("  understanding routing implementation details, agent ranking algorithms, service");
  lines.push("  architecture, or code structure of the connection-pacing FastAPI service.");
  lines.push("evolving: true");
  lines.push("source: " + SOURCE_URL);
  lines.push("---");
  lines.push("");
  lines.push("# Connection-Pacing Routing Service");
  lines.push("");
  lines.push("> **Source:** connection-pacing repo `CLAUDE.md`");
  lines.push("> **Last refreshed:** " + date);
  lines.push("> **Refresh command:** `bash .agents/skills/connection-pacing-routing/refresh.sh`");
  lines.push("");
  lines.push("This skill provides implementation-level context about the connection-pacing FastAPI service");
  lines.push("that produces ranked agent lists for connection attempts. For the high-level system overview");
  lines.push("(ZIP forecasts \u2192 BUA \u2192 agent targets \u2192 routing), see the `system-overview` skill.");
  lines.push("");
  lines.push("---");
  lines.push("");
  lines.push(raw);
  lines.push("");
  return lines.join("\n");
}

main().catch((err) => {
  console.error("Refresh failed:", err);
  process.exit(1);
});
