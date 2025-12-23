import * as fs from "fs";
import * as path from "path";

import type { OpenAPIOperation } from "../types";
import type { GeneratorContext } from "./utils";
import {
  getMethodParams,
  getPathParams,
  getQueryParams,
  getRequestBodyType,
  getResponseType,
  replacePathParams,
  toCamelCase,
  toPascalCase,
  toSnakeCase,
} from "./utils";

export function generateServices(ctx: GeneratorContext): void {
  const paths = ctx.spec.paths || {};
  const services: Map<string, OpenAPIOperation[]> = new Map();

  for (const [p, methods] of Object.entries(paths)) {
    for (const [method, operation] of Object.entries(methods)) {
      if (!operation.operationId) continue;

      const tag = operation.tags?.[0] || "default";
      if (!services.has(tag)) {
        services.set(tag, []);
      }

      (services.get(tag) as OpenAPIOperation[]).push({
        ...operation,
        _path: p,
        _method: method.toUpperCase(),
      } as any);
    }
  }

  for (const [tag, operations] of services.entries()) {
    const serviceCode = generateService(tag, operations, ctx);
    const filePath = path.join(
      ctx.outputDir,
      "lib",
      "services",
      `${toSnakeCase(tag)}_service.dart`
    );
    fs.writeFileSync(filePath, serviceCode);
  }
}

function generateService(
  serviceName: string,
  operations: any[],
  ctx: GeneratorContext
): string {
  const className = `${toPascalCase(serviceName)}Service`;
  let methods = "";

  for (const op of operations) {
    let methodName = op.operationId || "unknown";
    methodName = methodName.replace(/^[a-z]+Controller/i, "");
    methodName = toCamelCase(methodName);
    const httpMethod = op._method.toLowerCase();
    const servicePath = op._path;

    const requestBodyType = getRequestBodyType(op, ctx);
    const responseType = getResponseType(op, ctx);

    const params = getMethodParams(op, ctx);
    const pathParams = getPathParams(op);
    const queryParams = getQueryParams(op);

    methods += generateMethod(
      methodName,
      httpMethod,
      servicePath,
      requestBodyType,
      responseType,
      params,
      pathParams,
      queryParams
    );
  }

  const modelsExport = fs.existsSync(path.join(ctx.outputDir, "lib", "models"))
    ? "import '../models/models.dart';"
    : "";

  return `import 'package:fdl_core/fdl_core.dart';
${modelsExport}

class ${className} {
  final ApiClient _client;

  ${className}(this._client);

${methods}
}
`;
}

function generateMethod(
  methodName: string,
  httpMethod: string,
  servicePath: string,
  requestBodyType: string | null,
  responseType: string,
  params: string,
  pathParams: string[],
  queryParams: string[]
): string {
  const pathWithParams = replacePathParams(servicePath, pathParams);
  const queryMap =
    queryParams.length > 0
      ? `\n      query: {\n${queryParams
          .map((p) => `        '${p}': ${toCamelCase(p)}`)
          .join(",\n")},\n      },`
      : "";

  const bodyParamName = requestBodyType
    ? toCamelCase(requestBodyType.replace(/Request$/, ""))
    : null;
  const bodyParam = bodyParamName
    ? `\n      body: ${bodyParamName}?.toJson(),`
    : "";

  const isPrimitiveResponse = [
    "String",
    "num",
    "bool",
    "int",
    "double",
  ].includes(responseType);
  const responseExtraction = isPrimitiveResponse
    ? `return responseData as ${responseType};`
    : `return ${responseType}.fromJson(responseData as Map<String, dynamic>);`;

  return `
  Future<${responseType}> ${methodName}(${params}) async {
    final response = await _client.${httpMethod}(
      path: '${pathWithParams}',${bodyParam}${queryMap}
    );
    
    if (response.data != null && response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if (data.containsKey('data')) {
        final responseData = data['data'];
        if (responseData != null) {
          ${responseExtraction}
        }
      }
    }
    
    throw Exception('Invalid response format');
  }
`;
}
