export interface OpenAPISpec {
  openapi: string;
  info: {
    title: string;
    version: string;
  };
  paths: Record<string, Record<string, OpenAPIOperation>>;
  components: {
    schemas: Record<string, OpenAPISchema>;
  };
}

export interface OpenAPIOperation {
  operationId?: string;
  summary?: string;
  tags?: string[];
  requestBody?: {
    content: {
      "application/json": {
        schema: OpenAPISchemaRef;
      };
    };
  };
  parameters?: OpenAPIParameter[];
  responses: Record<string, OpenAPIResponse>;
}

export interface OpenAPIResponse {
  description?: string;
  content?: {
    "application/json": {
      schema: OpenAPISchemaRef;
    };
  };
}

export interface OpenAPISchemaRef {
  $ref?: string;
  type?: string;
  properties?: Record<string, OpenAPISchemaRef>;
  items?: OpenAPISchemaRef;
  enum?: string[];
  required?: string[];
  format?: string;
  nullable?: boolean;
  allOf?: OpenAPISchemaRef[];
  oneOf?: OpenAPISchemaRef[];
  anyOf?: OpenAPISchemaRef[];
}

export interface OpenAPISchema extends OpenAPISchemaRef {
  type: string;
  properties?: Record<string, OpenAPISchemaRef>;
  required?: string[];
}

export interface OpenAPIParameter {
  name: string;
  in: "query" | "path" | "header";
  required?: boolean;
  schema: OpenAPISchemaRef;
}

export interface DartType {
  name: string;
  type: "primitive" | "class" | "array" | "enum" | "Date";
}
