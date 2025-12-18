import { BadRequestException } from '@nestjs/common';
import { ZodError } from 'zod';
import { $ZodIssue } from 'zod/v4/core';

// type User = {
//   name: string;
//   age: number;
//   profile: {
//     bio: string;
//     avatar_file_id: string;
//   };
// };

export type ValidationIssue<T = unknown> = {
  code: string;
  data?: T;
};
export type ValidationError = Record<string, ValidationIssue[]>;

const formatError = (error: ZodError): ValidationError => {
  return error.issues.reduce(
    (acc, issue) => {
      const key = issue.path.join('.');
      const currentValue = acc[key];
      const error: ValidationIssue = {
        code: issue.message,
        data: extractValidationDataFromIssues(issue),
      };
      if (acc[key]) {
        currentValue.push(error);
      } else {
        acc[key] = [error];
      }
      return acc;
    },
    {} as Record<string, ValidationIssue[]>,
  );
};

export class ValidationException extends BadRequestException {
  static MESSAGE = 'VALIDATION_ERROR';

  constructor(
    public readonly zodError?: ZodError,
    public readonly message: string = ValidationException.MESSAGE,
  ) {
    super({
      message: message,
      errors: zodError != undefined ? formatError(zodError) : [],
    });
  }
}

const extractValidationDataFromIssues = (
  issue: $ZodIssue,
): Record<any, any> => {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const { code, message, path, input, ...rest } = issue;
  delete (rest as Record<string, unknown>).origin;
  return rest;
};
