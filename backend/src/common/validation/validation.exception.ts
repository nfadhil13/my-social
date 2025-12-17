import { BadRequestException } from '@nestjs/common';
import { ZodError } from 'zod';

// type User = {
//   name: string;
//   age: number;
//   profile: {
//     bio: string;
//     avatar_file_id: string;
//   };
// };

export type ValidationError = Record<string, string[]>;

const formatError = (error: ZodError): ValidationError => {
  return error.issues.reduce(
    (acc, issue) => {
      const key = issue.path.join('.');
      const currentValue = acc[key];
      if (acc[key]) {
        currentValue.push(issue.message);
      } else {
        acc[key] = [issue.message];
      }
      return acc;
    },
    {} as Record<string, string[]>,
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
