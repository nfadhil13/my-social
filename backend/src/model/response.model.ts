import { applyDecorators, Type } from '@nestjs/common';
import {
  ApiExtraModels,
  ApiOkResponse,
  ApiProperty,
  getSchemaPath,
} from '@nestjs/swagger';

export class ResponseModel<T = unknown> {
  @ApiProperty({ description: 'Response message' })
  message: string;
  data: T;
  @ApiProperty({ description: 'Response success' })
  success: boolean;
  @ApiProperty({ description: 'Response errors' })
  errors?: Record<string, any>;
}

export function successResponse<T>(data: T, message: string): ResponseModel<T> {
  return {
    message,
    data,
    success: true,
  };
}

export const ApiOkResponseCustom = <T extends Type<unknown>>(data: T) => {
  let dataContent = {};
  if (data instanceof Object) {
    dataContent = {
      $ref: getSchemaPath(data),
    };
  } else if (Array.isArray(data)) {
    dataContent = {
      type: 'array',
      items: {
        $ref: getSchemaPath(data[0]),
      },
    };
  } else {
    dataContent = {
      type: typeof data,
    };
  }
  return applyDecorators(
    ApiExtraModels(ResponseModel, data),
    ApiOkResponse({
      schema: {
        allOf: [
          { $ref: getSchemaPath(ResponseModel) },
          // { $ref: getSchemaPath(data) },
          {
            type: 'object',
            properties: {
              data: dataContent,
            },
          },
        ],
      },
    }),
  );
};
