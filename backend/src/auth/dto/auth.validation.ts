import { z } from 'zod';
import { VALIDATION_ERRORS } from '../../common/validation/validation.error';
export class AuthValidation {
  static readonly REGISTER = z
    .object({
      email: z
        .string(VALIDATION_ERRORS.REQUIRED)
        .email(VALIDATION_ERRORS.EMAIL_INVALID)
        .min(1, VALIDATION_ERRORS.REQUIRED),
      name: z
        .string(VALIDATION_ERRORS.REQUIRED)
        .min(1, VALIDATION_ERRORS.REQUIRED),
      username: z
        .string(VALIDATION_ERRORS.REQUIRED)
        .min(1, VALIDATION_ERRORS.REQUIRED)
        .regex(/^[a-z0-9]+$/, VALIDATION_ERRORS.REGEX),
      password: z
        .string(VALIDATION_ERRORS.REQUIRED)
        .min(8, VALIDATION_ERRORS.MIN_LENGTH)
        .regex(
          /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/,
          VALIDATION_ERRORS.REGEX,
        )
        .max(20, VALIDATION_ERRORS.MAX_LENGTH),
    })
    .meta({
      description: 'Register request body',
      example: {
        email: 'test@example.com',
        name: 'John Doe',
        username: 'john_doe',
        password: 'Password123!',
      },
    });

  static readonly LOGIN = z
    .object({
      email: z
        .string(VALIDATION_ERRORS.REQUIRED)
        .email(VALIDATION_ERRORS.EMAIL_INVALID)
        .min(1, VALIDATION_ERRORS.REQUIRED),
      password: z
        .string(VALIDATION_ERRORS.REQUIRED)
        .min(1, VALIDATION_ERRORS.REQUIRED),
    })
    .meta({
      description: 'Login request body',
      example: {
        email: 'test@example.com',
        password: 'Password123!',
      },
    });
}
