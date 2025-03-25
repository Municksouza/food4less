const esbuild = require("esbuild");

esbuild.build({
  entryPoints: ["app/javascript/application.js"], // Arquivo principal
  bundle: true,
  format: "esm",
  sourcemap: true,
  minify: false,
  target: ["esnext"],
  outdir: "app/assets/builds",
  publicPath: "/assets",
  logLevel: "info",
  platform: "browser",
  define: { "process.env.NODE_ENV": '"development"' },
}).catch(() => process.exit(1));