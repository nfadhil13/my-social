import * as fs from "fs";
import * as path from "path";

import type { OpenAPISpec } from "../types";
import { generateMainExport } from "./generateMainExport";
import { generateModels, generateResponseModel } from "./generateModel";
import { generateServices } from "./generateServices";
import type { GeneratorContext } from "./utils";

export function generateDartSdk(spec: OpenAPISpec, outputDir: string): void {
  const ctx: GeneratorContext = {
    spec,
    outputDir,
    schemas: new Map<string, string>(),
  };

  ensureOutputDir(ctx);
  generateResponseModel({ ctx });
  generateModels(ctx);
  generateServices(ctx);
  generateMainExport(ctx);
}

function ensureOutputDir(ctx: GeneratorContext): void {
  const libDir = path.join(ctx.outputDir, "lib");
  const modelsDir = path.join(libDir, "models");
  const servicesDir = path.join(libDir, "services");

  [libDir, modelsDir, servicesDir].forEach((dir) => {
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
  });
}
