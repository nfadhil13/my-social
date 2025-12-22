import { AuthValidation } from './auth.validation';
import { UserResponse } from './user-response.dto';
import { ApiProperty } from '@nestjs/swagger';
import { Z } from 'zod-class';

export class LoginDto extends Z.class(AuthValidation.LOGIN.shape) {
  @ApiProperty({ description: 'User email', example: 'test@example.com' })
  email: string;

  @ApiProperty({ description: 'User password', example: 'Password123!' })
  password: string;
}

export class LoginResponse {
  @ApiProperty({ description: 'User information' })
  user: UserResponse;

  @ApiProperty({ description: 'Access token' })
  accessToken: string;
}
