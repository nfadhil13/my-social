import { ZodError } from 'zod';
import { $ZodIssue } from 'zod/v4/core';
import { DomainException } from '../error/domain.exception';
import { DomainErrorType } from '../error/domain.error';

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

export class ValidationException extends DomainException {
  static MESSAGE = 'VALIDATION_ERROR';
  public readonly errors?: ValidationError;
  constructor(zodError?: ZodError) {
    super({
      code: ValidationException.MESSAGE,
      type: DomainErrorType.VALIDATION,
    });
    this.errors = zodError != undefined ? formatError(zodError) : undefined;
  }
}

export const getErrorFromDomainException = (
  exception: DomainException,
): ValidationError | undefined => {
  if (exception instanceof ValidationException) {
    return exception.errors;
  }
  return undefined;
};

const extractValidationDataFromIssues = (
  issue: $ZodIssue,
): Record<any, any> => {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const { code, message, path, input, ...rest } = issue;
  delete (rest as Record<string, unknown>).origin;
  return rest;
};
