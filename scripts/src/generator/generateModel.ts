import * as fs from "fs";
import * as path from "path";

import type { GeneratorContext } from "./utils";
import {
  getDartType,
  getFromJsonValue,
  getToJsonValue,
  toCamelCase,
  toPascalCase,
  toSnakeCase,
} from "./utils";
import type { OpenAPISchema } from "../types";

export function generateModels(ctx: GeneratorContext): void {
  const schemas = ctx.spec.components?.schemas || {};

  for (const [schemaName, schema] of Object.entries(schemas)) {
    if (
      schemaName === "ResponseModel" ||
      schemaName.toLowerCase() === "responsemodel"
    ) {
      continue;
    }

    if (!isObject(schema)) {
      continue;
    }

    const dartClassName = toPascalCase(schemaName);
    const modelCode = generateModel(
      dartClassName,
      schema as OpenAPISchema,
      ctx
    );

    const filePath = path.join(
      ctx.outputDir,
      "lib",
      "models",
      `${toSnakeCase(schemaName)}.dart`
    );
    fs.writeFileSync(filePath, modelCode);
    ctx.schemas.set(schemaName, dartClassName);
  }

  const modelsExport = Array.from(ctx.schemas.values())
    .map((name) => `export '${toSnakeCase(name)}.dart';`)
    .join("\n");

  fs.writeFileSync(
    path.join(ctx.outputDir, "lib", "models", "models.dart"),
    `library models;\n\n${modelsExport}\n`
  );
}

function isObject(schema: OpenAPISchema): boolean {
  return schema.type === "object" && schema.properties !== undefined;
}

function generateModel(
  className: string,
  schema: OpenAPISchema,
  ctx: GeneratorContext
): string {
  const properties = schema.properties || {};
  const required = schema.required || [];

  let imports = "";
  let fields = "";
  let constructorParams = "";
  let fromJsonBody = "";
  let toJsonBody = "";
  let enums = "";

  for (const [propName, propSchema] of Object.entries(properties)) {
    const dartType = getDartType(propSchema, propName, ctx);
    const isRequired = required.includes(propName);
    const fieldName = toCamelCase(propName);
    const fieldDartType =
      dartType.type === "enum"
        ? `${className}${toPascalCase(propName)}Enum`
        : dartType.name;

    if (dartType.type === "class") {
      imports += createImportString({ dartType: dartType.name });
    }
    if (dartType.type === "enum") {
      enums += createEnum({
        name: fieldDartType,
        values: propSchema.enum ?? [],
      });
    }
    fields += createFieldString({
      isRequired,
      dartType: fieldDartType,
      fieldName,
    });
    constructorParams += createConstructorParamsString({
      isRequired,
      fieldName,
    });
    const isResponse = className.toLowerCase().endsWith("response");
    // if (isResponse) {
    //   toJsonBody += `      '${propName}': ${getToJsonValue(
    //     propSchema,
    //     fieldName
    //   )},\n`;
    // } else {
    //   if (isRequired) {
    //     fromJsonBody += `      ${fieldName}: ${getFromJsonValue(
    //       propSchema,
    //       `json['${propName}']`,
    //       propName,
    //       ctx
    //     )},\n`;
    //   } else {
    //     fromJsonBody += `      ${fieldName}: json['${propName}'] != null ? ${getFromJsonValue(
    //       propSchema,
    //       `json['${propName}']`,
    //       propName,
    //       ctx
    //     )} : null,\n`;
    //   }
    // }
  }

  return createClass({
    imports,
    className,
    fields,
    constructorParams,
    fromJsonBody,
    toJsonBody,
    enums,
  });
}

function createImportString({ dartType }: { dartType: string }): string {
  return `import '${toSnakeCase(dartType)}.dart';\n`;
}

function createFieldString({
  isRequired,
  dartType,
  fieldName,
}: {
  isRequired: boolean;
  dartType: string;
  fieldName: string;
}): string {
  return `  final ${isRequired ? dartType : "$dartType?"} ${fieldName};\n`;
}

function createConstructorParamsString({
  isRequired,
  fieldName,
}: {
  isRequired: boolean;
  fieldName: string;
}): string {
  return `${isRequired ? "required " : ""}this.${fieldName},\n    `;
}

function createClass({
  imports,
  className,
  fields,
  constructorParams,
  fromJsonBody,
  toJsonBody,
  enums,
}: {
  imports: string;
  className: string;
  fields: string;
  constructorParams: string;
  fromJsonBody: string;
  toJsonBody: string;
  enums: string;
}): string {
  return `${imports}
class ${className} {
${fields}
${className}({ ${constructorParams} });

}
${enums}\n
`;
}

function createEnum({
  name,
  values,
}: {
  name: string;
  values: string[];
}): string {
  return `enum ${name} {
    ${values
      .map((value) => `  ${toCamelCase(value.toLowerCase())}`)
      .join("\n, ")}
  }
  `;
}
