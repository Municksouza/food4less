const esbuild = require("esbuild");

esbuild.build({
  entryPoints: ["app/javascript/application.js"], // Main entry point for the application 
  bundle: true,
  format: "esm",
  sourcemap: "inline",
  minify: false, 
  target: ["esnext"],
  outdir: "app/assets/builds",
  publicPath: "/assets",
  logLevel: "info",
  platform: "browser",
  define: { "process.env.NODE_ENV": '"development"' },
  alias: {
    "@popperjs/core/dist/esm/utils/getBasePlacement.js": "./app/javascript/poppers/my-get-base-placement.js"
  },
  loader: {
    ".js": "jsx",           // if you need JSX support
    ".css": "css",          // if you import CSS
    ".png": "file",
    ".svg": "file",
    ".jpg": "file",
    ".jpeg": "file",
    ".gif": "file",
    ".woff": "file",
    ".woff2": "file",
    ".ttf": "file",
    ".eot": "file",
  },
}).catch(() => process.exit(1));