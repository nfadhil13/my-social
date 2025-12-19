import { z } from 'zod';
import { AuthValidation } from './auth.validation';
import { UserResponse } from './user-response.dto';

export type LoginDto = z.infer<typeof AuthValidation.LOGIN>;

export type LoginResponse = {
  user: UserResponse;
  accessToken: string;
};
