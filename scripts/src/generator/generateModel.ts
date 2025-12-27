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
import type { OpenAPISchema, OpenAPISchemaRef } from "../types";

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

  let modelsExport = Array.from(ctx.schemas.values())
    .map((name) => `export '${toSnakeCase(name)}.dart';`)
    .join("\n");

  modelsExport += `export 'response_model.dart';`;

  fs.writeFileSync(
    path.join(ctx.outputDir, "lib", "models", "models.dart"),
    `library ;\n\n${modelsExport}\n`
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
    const isRequired = !(propSchema.nullable === true);
    const fieldName = toCamelCase(propName);
    const fieldDartType =
      dartType.type === "enum"
        ? `${className}${toPascalCase(propName)}Enum`
        : dartType.name;
    console.log(propName);
    console.log(fieldDartType);

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
    if (isResponse) {
      fromJsonBody += createFromJsonItem({
        propSchema,
        propName: dartType.type === "enum" ? fieldDartType : propName,
        fieldName,
        isRequired,
        ctx,
      });
    } else {
      toJsonBody += createToJsonItem({
        propSchema,
        propName: dartType.type === "enum" ? fieldDartType : propName,
        fieldName,
        ctx,
      });
    }
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

${createFromJson({ className, fromJsonBody })}

${createToJson({ className, toJsonBody })}

}
${enums}\n
`;
}

function createFromJson({
  className,
  fromJsonBody,
}: {
  className: string;
  fromJsonBody: string;
}): string {
  if (fromJsonBody.length === 0) return "";
  if (!className.toLowerCase().endsWith("response")) return "";
  return `
  factory ${className}.fromJson(dynamic json) {
    return ${className}(
      ${fromJsonBody}
    );
  }
  `;
}

function createToJson({
  className,
  toJsonBody,
}: {
  className: string;
  toJsonBody: string;
}): string {
  if (toJsonBody.length === 0) return "";
  if (className.toLowerCase().endsWith("response")) return "";
  return `
  dynamic toJson() {
    return {
      ${toJsonBody}
    };
  }
  `;
}

function createToJsonItem({
  fieldName,
  propSchema,
  propName,
  ctx,
}: {
  fieldName: string;
  propSchema: OpenAPISchemaRef;
  propName: string;
  ctx: GeneratorContext;
}): string {
  return `      '${toCamelCase(propName)}': ${getToJsonValue(
    propSchema,
    fieldName,
    ctx
  )},\n`;
}
function createFromJsonItem({
  isRequired,
  propSchema,
  propName,
  fieldName,
  ctx,
}: {
  isRequired: boolean;
  ctx: GeneratorContext;
  propSchema: OpenAPISchemaRef;
  propName: string;
  fieldName: string;
}): string {
  if (isRequired) {
    return `      ${fieldName}: ${getFromJsonValue(
      propSchema,
      `json['${propName}']`,
      propName,
      ctx
    )},\n`;
  }
  return `      ${fieldName}: json['${propName}'] != null ? ${getFromJsonValue(
    propSchema,
    `json['${propName}']`,
    propName,
    ctx
  )} : null,\n`;
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
  return `  final ${isRequired ? dartType : `${dartType}?`} ${fieldName};\n`;
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

function createEnum({
  name,
  values,
}: {
  name: string;
  values: string[];
}): string {
  return `enum ${name} {


    ${values
      .map((value) => `  ${toCamelCase(value.toLowerCase())}('${value}')`)
      .join("\n, ")};
    
    final String value;

    const ${name}(this.value);

    static ${name} fromJson(String value) {
      return ${name}.values.firstWhere((e) => e.value == value);
    }
  }
  `;
}

export function generateResponseModel({ ctx }: { ctx: GeneratorContext }) {
  const responseModelCode = `class ResponseModel<T> {
    final String message;
    final T data;

    ResponseModel({ required this.message, required this.data });

    static ResponseModel<T> fromJson<T>(dynamic json, T data) {
      return ResponseModel<T>(
        message: json['message'],
        data: data,
      );
    }
  }
  `;

  fs.writeFileSync(
    path.join(ctx.outputDir, "lib", "models", "response_model.dart"),
    responseModelCode
  );
}
