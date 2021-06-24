module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "google",
    "plugin:@typescript-eslint/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: ["tsconfig.json", "tsconfig.dev.json"],
    sourceType: "module",
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
  ],
  plugins: [
    "@typescript-eslint",
    "import",
  ],
  rules: {
    "quotes": ["error", "double"],
    "max-len": ["error", {"code": 160}],
    "require-jsdoc": 0,
    // "variable-name": 0,
    "camelcase": "off",
    "new-cap": 0,
    "no-unused-vars": ["warn", {"vars": "all", "args": "after-used", "ignoreRestSiblings": false}],
  },
};
