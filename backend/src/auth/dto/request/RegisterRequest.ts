import { Z } from 'zod-class';
import { AuthValidation } from '../auth.validation';
import { ApiProperty } from '@nestjs/swagger';

export class RegisterRequest extends Z.class(AuthValidation.REGISTER.shape) {
  @ApiProperty({
    description: 'User email',
    example: 'test@example.com',
  })
  email: string;

  @ApiProperty({
    description: 'User password',
    example: 'Password123!',
  })
  password: string;

  @ApiProperty({
    description: 'User name',
    example: 'John Doe',
  })
  name: string;

  @ApiProperty({
    description: 'User username',
    example: 'john_doe',
  })
  username: string;
}
