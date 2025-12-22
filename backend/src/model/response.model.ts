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
  @ApiProperty({ description: 'Response data' })
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

export const ApiOkResponseCustom = <T extends Type<unknown>>(data: T) =>
  applyDecorators(
    ApiExtraModels(ResponseModel, data),
    ApiOkResponse({
      description: `The paginated result of ${data.name}`,
      schema: {
        allOf: [
          { $ref: getSchemaPath(ResponseModel) },
          {
            properties: {
              data: {
                type: data instanceof Array ? 'array' : 'object',
                $ref: data instanceof Array ? undefined : getSchemaPath(data),
                items:
                  data instanceof Array
                    ? { $ref: getSchemaPath(data) }
                    : undefined,
              },
            },
          },
        ],
      },
    }),
  );
