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
  }
}).catch(() => process.exit(1));