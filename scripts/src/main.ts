#!/usr/bin/env node

import * as fs from "fs";
import * as path from "path";

import type { OpenAPISpec } from "./types";
import { fetchJson } from "./fetchJSON";
import { generateDartSdk } from "./generator";

async function main(): Promise<void> {
  const args = process.argv.slice(2);
  const specPath = args[0] || "http://localhost:3000/api-json";
  const outputDir = path.resolve(
    args[1] || path.join("..", "mobile", "packages", "my_social_sdk")
  );

  let spec: OpenAPISpec;

  if (specPath.startsWith("http://") || specPath.startsWith("https://")) {
    spec = await fetchJson(specPath);
  } else {
    spec = JSON.parse(fs.readFileSync(specPath, "utf-8"));
  }

  generateDartSdk(spec, outputDir);

  console.log(`✅ SDK generated successfully at ${outputDir}`);
}

main().catch(console.error);
