import { z } from 'zod';

export class AuthValidation {
  static readonly REGISTER = z.object({
    email: z.string().email().min(1),
    password: z
      .string()
      .min(8)
      .regex(
        /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/,
        {
          message: 'PASSWORD_RULES',
        },
      )
      .max(20),
  });

  static readonly LOGIN = z.object({
    email: z.string().email().min(1),
    password: z.string().min(1),
  });
}
