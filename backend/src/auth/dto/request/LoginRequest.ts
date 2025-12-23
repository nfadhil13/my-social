import { AuthValidation } from '../auth.validation';
import { ApiProperty } from '@nestjs/swagger';
import { Z } from 'zod-class';

export class LoginRequest extends Z.class(AuthValidation.LOGIN.shape) {
  @ApiProperty({ description: 'User email', example: 'test@example.com' })
  email: string;

  @ApiProperty({ description: 'User password', example: 'Password123!' })
  password: string;
}
