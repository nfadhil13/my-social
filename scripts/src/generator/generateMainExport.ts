import * as fs from "fs";
import * as path from "path";

import type { GeneratorContext } from "./utils";

export function generateMainExport(ctx: GeneratorContext): void {
  const modelsDir = path.join(ctx.outputDir, "lib", "models");
  const models = fs.existsSync(modelsDir)
    ? fs
        .readdirSync(modelsDir)
        .filter((f) => f.endsWith(".dart") && !f.endsWith(".g.dart"))
        .map((f) => `export 'models/${f}';`)
        .join("\n")
    : "";

  const servicesDir = path.join(ctx.outputDir, "lib", "services");
  const services = fs.existsSync(servicesDir)
    ? fs
        .readdirSync(servicesDir)
        .filter((f) => f.endsWith(".dart"))
        .map((f) => `export 'services/${f}';`)
        .join("\n")
    : "";

  const mainContent = `library my_social_sdk;

${models}
${services}
`;

  fs.writeFileSync(
    path.join(ctx.outputDir, "lib", "my_social_sdk.dart"),
    mainContent
  );
}
