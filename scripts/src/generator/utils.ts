import type {
  OpenAPISchemaRef,
  OpenAPIOperation,
  OpenAPISpec,
  DartType,
} from "../types";

export interface GeneratorContext {
  spec: OpenAPISpec;
  outputDir: string;
  schemas: Map<string, string>;
}

export function toPascalCase(str: string): string {
  if (str.match(/^[A-Z][a-zA-Z0-9]*$/)) {
    return str;
  }
  if (str.match(/^[a-z][a-zA-Z0-9]*$/)) {
    return str.charAt(0).toUpperCase() + str.slice(1);
  }
  return str
    .split(/[-_\s]/)
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
    .join("");
}

export function toCamelCase(str: string): string {
  const pascal = toPascalCase(str);
  return pascal.charAt(0).toLowerCase() + pascal.slice(1);
}

export function toSnakeCase(str: string): string {
  return str
    .replace(/([A-Z])/g, "_$1")
    .toLowerCase()
    .replace(/^_/, "");
}

export function getDartType(
  schema: OpenAPISchemaRef,
  propName: string,
  ctx: GeneratorContext
): DartType {
  if (schema.$ref) {
    const refName = schema.$ref.split("/").pop() as string;
    if (ctx.schemas.has(refName)) {
      return {
        name: ctx.schemas.get(refName) as string,
        type: "class",
      };
    }
    return {
      name: toPascalCase(refName),
      type: "class",
    };
  }
  const schemaAllOf = schema.allOf;
  if (schemaAllOf != undefined && schemaAllOf.length > 0) {
    const firstRef = schemaAllOf[0]!.$ref;
    if (firstRef) {
      const refName = firstRef.split("/").pop() as string;
      let name: string | undefined;
      if (ctx.schemas.has(refName)) {
        name = ctx.schemas.get(refName) as string;
      }
      return {
        name: name ?? toPascalCase(refName),
        type: "class",
      };
    }
  }

  // Date
  if (schema.type === "string" && schema.format === "date-time") {
    return {
      name: "DateTime",
      type: "Date",
    };
  }

  if (schema.type === "array") {
    const itemType = schema.items
      ? getDartType(schema.items, "", ctx)
      : {
          name: "dynamic",
          type: "primitive",
        };
    return {
      name: `List<${itemType.name}>`,
      type: "array",
    };
  }

  if (schema.type === "object") {
    return {
      name: "Map<String, dynamic>",
      type: "primitive",
    };
  }

  if (schema.enum) {
    return {
      name: `${toPascalCase(propName)}Enum`,
      type: "enum",
    };
  }

  switch (schema.type) {
    case "string":
      return {
        name: "String",
        type: "primitive",
      };
    case "integer":
    case "number":
      return {
        name: "num",
        type: "primitive",
      };
    case "boolean":
      return {
        name: "bool",
        type: "primitive",
      };
    default:
      return {
        name: "dynamic",
        type: "primitive",
      };
  }
}

export function getFromJsonValue(
  schema: OpenAPISchemaRef,
  jsonPath: string,
  propName: string,
  ctx: GeneratorContext
): string {
  if (schema.$ref) {
    const refName = schema.$ref.split("/").pop() as string;
    let className = ctx.schemas.get(refName);
    if (!className) {
      const normalizedName = refName.replace(/Dto$/i, "Request");
      className = toPascalCase(normalizedName);
    }
    return `${className}.fromJson(${jsonPath} as Map<String, dynamic>)`;
  }

  if (schema.type === "string" && schema.format === "date-time") {
    return `DateTime.parse(${jsonPath} as String)`;
  }

  if (
    schema.type === undefined &&
    schema.allOf != undefined &&
    schema.allOf.length > 0
  ) {
    const firstRef = schema.allOf[0]!.$ref;
    if (firstRef) {
      const refName = firstRef.split("/").pop() as string;
      let className = ctx.schemas.get(refName);
      if (!className) {
        className = toPascalCase(refName);
      }
      return `${className}.fromJson(${jsonPath} as Map<String, dynamic>)`;
    }
  }

  if (schema.type === "array") {
    const itemType = schema.items
      ? getDartType(schema.items, "", ctx)
      : "dynamic";
    if (schema.items?.$ref) {
      const refName = schema.items.$ref.split("/").pop() as string;
      let className = ctx.schemas.get(refName);
      if (!className) {
        const normalizedName = refName.replace(/Dto$/i, "Request");
        className = toPascalCase(normalizedName);
      }
      return `(${jsonPath} as List).map((e) => ${className}.fromJson(e as Map<String, dynamic>)).toList()`;
    }
    return `${jsonPath} as List<${itemType}>`;
  }

  if (schema.type === "string" && schema.enum) {
    return `${toPascalCase(propName)}.fromJson(${jsonPath} as String)`;
  }

  return `${jsonPath} as ${getDartType(schema, propName, ctx).name}`;
}

export function getToJsonValue(
  schema: OpenAPISchemaRef,
  fieldName: string,
  ctx: GeneratorContext
): string {
  if (schema.$ref || (schema.type === "object" && schema.properties)) {
    return `${fieldName}.toJson()`;
  }

  if (schema.type === "string" && schema.format === "date-time") {
    return `${fieldName}.toIso8601String()`;
  }

  if (
    schema.type === undefined &&
    schema.allOf != undefined &&
    schema.allOf.length > 0
  ) {
    const firstRef = schema.allOf[0]!.$ref;
    if (firstRef) {
      const refName = firstRef.split("/").pop() as string;
      return `${fieldName}.toJson()`;
    }
  }

  if (schema.enum) {
    return `${fieldName}.value`;
  }

  if (schema.type === "array" && schema.items?.$ref) {
    return `${fieldName}.map((e) => e.toJson()).toList()`;
  }

  return fieldName;
}

export function getRequestBodyType(
  operation: OpenAPIOperation,
  ctx: GeneratorContext
): string | null {
  const requestBody =
    operation.requestBody?.content?.["application/json"]?.schema;
  if (!requestBody) return null;

  if (requestBody.$ref) {
    const refName = requestBody.$ref.split("/").pop() as string;
    const normalizedName = refName.replace(/Dto$/i, "Request");
    return ctx.schemas.get(refName) || toPascalCase(normalizedName);
  }

  return null;
}

export function isPrimitiveSchema(schema: OpenAPISchemaRef): boolean {
  if (schema.$ref) {
    const refName = schema.$ref.split("/").pop() as string;
    return refName === "String" || refName === "string";
  }
  return schema.type === "string" && !schema.enum;
}

export function getPrimitiveDartType(schema: OpenAPISchemaRef): string {
  if (schema.$ref) {
    const refName = schema.$ref.split("/").pop() as string;
    if (refName === "String" || refName === "string") {
      return "String";
    }
  }
  if (schema.type === "string") {
    return "String";
  }
  if (schema.type === "number" || schema.type === "integer") {
    return "num";
  }
  if (schema.type === "boolean") {
    return "bool";
  }
  return "dynamic";
}

export function getResponseType(
  operation: OpenAPIOperation,
  ctx: GeneratorContext
): string {
  const successResponse =
    operation.responses["200"] || operation.responses["201"];
  if (!successResponse?.content?.["application/json"]?.schema) {
    return "dynamic";
  }

  const schema = successResponse.content["application/json"].schema;

  if (schema.allOf) {
    for (const subSchema of schema.allOf) {
      if (subSchema.properties?.data) {
        const dataSchema = subSchema.properties.data;
        if (isPrimitiveSchema(dataSchema)) {
          return getPrimitiveDartType(dataSchema);
        }
        const dartType = getDartType(dataSchema, "", ctx);
        return dartType.name;
      }
    }
  }

  if (schema.$ref) {
    const refName = schema.$ref.split("/").pop() as string;
    if (
      refName === "ResponseModel" ||
      refName.toLowerCase() === "responsemodel"
    ) {
      return "dynamic";
    }
    return ctx.schemas.get(refName) || toPascalCase(refName);
  }

  if (schema.properties?.data) {
    const dataSchema = schema.properties.data;
    if (isPrimitiveSchema(dataSchema)) {
      return getPrimitiveDartType(dataSchema);
    }
    const dartType = getDartType(dataSchema, "", ctx);
    return dartType.name;
  }

  return "dynamic";
}

export function getPathParams(operation: OpenAPIOperation): string[] {
  return (operation.parameters || [])
    .filter((p) => p.in === "path")
    .map((p) => p.name);
}

export function getQueryParams(operation: OpenAPIOperation): string[] {
  return (operation.parameters || [])
    .filter((p) => p.in === "query")
    .map((p) => p.name);
}

export function replacePathParams(
  servicePath: string,
  params: string[]
): string {
  let result = servicePath;
  params.forEach((p) => {
    result = result.replace(`{${p}}`, `\${${toCamelCase(p)}}`);
  });
  return result;
}

export function getMethodParams(
  operation: OpenAPIOperation,
  ctx: GeneratorContext
): string {
  const params: string[] = [];

  const pathParams = getPathParams(operation);
  pathParams.forEach((p) => {
    params.push(`required String ${toCamelCase(p)}`);
  });

  const queryParams = getQueryParams(operation);
  queryParams.forEach((p) => {
    params.push(`String? ${toCamelCase(p)}`);
  });

  const requestBodyType = getRequestBodyType(operation, ctx);
  if (requestBodyType) {
    const paramName = toCamelCase(requestBodyType.replace(/Request$/, ""));
    params.push(`${requestBodyType}? ${paramName}`);
  }

  return params.length > 0 ? params.join(", ") : "";
}
