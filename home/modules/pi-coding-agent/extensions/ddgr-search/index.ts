import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "web_search",
    label: "Web Search (DuckDuckGo)",
    description: "Search the web using DuckDuckGo via the ddgr command. Fast, no API key needed.",
    parameters: Type.Object({
      query: Type.String({ description: "The search query to execute" }),
      max_results: Type.Optional(Type.Number({ description: "Maximum number of results to return", default: 5 })),
    }),
    async execute(_toolCallId, params, signal, _onUpdate, ctx) {
      const maxResults = params.max_results ?? 5;
      const query = params.query;

      try {
        const result = await pi.exec("/usr/bin/env", ["ddgr", "--json", query, "-n", String(maxResults)], {
          signal,
          timeout: 15000,
          cwd: ctx.cwd,
        });

        if (result.code !== 0) {
          throw new Error(`ddgr exited with code ${result.code}: ${result.stderr}`);
        }

        if (!result.stdout.trim()) {
          return {
            content: [{ type: "text", text: `No results found for "${query}".` }],
          };
        }

        let results: any[];
        try {
          results = JSON.parse(result.stdout);
        } catch {
          // Not valid JSON — ddgr may have returned plain text
          return {
            content: [{ type: "text", text: result.stdout || `No results found for "${query}".` }],
          };
        }

        if (!Array.isArray(results) || results.length === 0) {
          return {
            content: [{ type: "text", text: `No results found for "${query}".` }],
          };
        }

        const formatted = results
          .map(
            (r: any, i: number) =>
              `${i + 1}. ${r.title}\n   URL: ${r.url}\n   ${r.abstract || r.snippet || r.description || ""}`
          )
          .join("\n\n");

        return {
          content: [{ type: "text", text: formatted }],
          details: { results: results.map((r: any) => ({ title: r.title, url: r.url, abstract: r.abstract })) },
        };
      } catch (error) {
        if (error instanceof Error && error.message.includes("command not found")) {
          throw new Error(`ddgr not found. Install it: nix profile install nixpkgs.ddgr`);
        }
        throw error;
      }
    },
  });

  pi.registerTool({
    name: "web_fetch",
    label: "Web Fetch",
    description: "Fetch the content of a webpage URL using curl and extract readable text",
    parameters: Type.Object({
      url: Type.String({ description: "URL to fetch" }),
    }),
    async execute(_toolCallId, params, signal, _onUpdate, ctx) {
      try {
        const result = await pi.exec("sh", [
          "-c",
          `curl -sL -H "Accept: text/html" '${params.url}' | html2text -nobs 2>/dev/null || curl -sL '${params.url}'`,
        ], {
          signal,
          timeout: 20000,
          cwd: ctx.cwd,
        });

        const output = result.stdout;
        const truncated = output.length > 10000 ? output.slice(0, 10000) + "\n... (truncated)" : output;

        return {
          content: [{ type: "text", text: truncated || `Could not fetch content from ${params.url}` }],
        };
      } catch (error) {
        throw error;
      }
    },
  });
}
