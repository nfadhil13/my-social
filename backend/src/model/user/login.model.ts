import { z } from 'zod';
import { AuthValidation } from './auth.validation';

export type LoginDto = z.infer<typeof AuthValidation.LOGIN>;
