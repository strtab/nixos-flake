import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
 
export default function (pi: ExtensionAPI) {
  // /clear: drop the context by starting a fresh session (same as /new)
  pi.registerCommand("clear", {
    description: "Clear context by starting a new session",
    handler: async (_args, ctx) => {
      await ctx.waitForIdle();
      await ctx.newSession();
    },
  });
 
  // ctrl+l: clear the terminal screen and scrollback, context is kept
  pi.registerShortcut("ctrl+l", {
    description: "Clear the screen",
    handler: async () => {
      // Erase display, erase scrollback, move cursor to top-left
      process.stdout.write("\x1b[2J\x1b[3J\x1b[H");
    },
  });
}
