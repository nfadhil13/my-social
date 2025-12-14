import { z } from 'zod';
import { AuthValidation } from './auth.validation';

export type RegisterDto = z.infer<typeof AuthValidation.REGISTER>;
