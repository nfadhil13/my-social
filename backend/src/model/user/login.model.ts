import { z } from 'zod';
import { AuthValidation } from './auth.validation';
import { User } from '../../common/prisma/client/client';

export type LoginDto = z.infer<typeof AuthValidation.LOGIN>;

export type LoginResponse = {
  user: Omit<User, 'password_hash' | 'created_at' | 'updated_at'>;
  accessToken: string;
};
