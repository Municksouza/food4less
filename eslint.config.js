export default [
  {
    ignores: ["node_modules/", "app/assets/builds/"],
  },
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: {
        window: "readonly",  // ✅ Permite usar window
        document: "readonly", // ✅ Permite usar document
        console: "readonly",  // ✅ Permite usar console.log
      },
    },
    rules: {
      "no-unused-vars": "warn",
      "no-undef": "off", // ✅ Desativa erros para variáveis globais do navegador
      "no-console": "off", // ✅ Desativa os avisos de console.log
    },
  },
];