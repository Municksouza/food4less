const esbuild = require('esbuild');
const { stimulusPlugin } = require('esbuild-plugin-stimulus');

esbuild.build({
  entryPoints: ["app/javascript/application.js"],
  bundle: true,
  sourcemap: "inline",
  plugins: [stimulusPlugin()],
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
    ".js": "jsx",
    ".css": "css",
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