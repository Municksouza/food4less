const esbuild = require("esbuild");

esbuild.build({
  entryPoints: ["app/javascript/application.js"], // Arquivo principal
  bundle: true,
  format: "esm",
  sourcemap: "inline", // ou true para sourcemaps externos
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