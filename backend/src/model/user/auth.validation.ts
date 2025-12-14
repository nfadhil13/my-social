import { z } from 'zod';

export class AuthValidation {
  static readonly REGISTER = z.object({
    email: z.string().email().min(1),
    password: z.string().min(1),
  });

  static readonly LOGIN = z.object({
    email: z.string().email().min(1),
    password: z.string().min(1),
  });
}
