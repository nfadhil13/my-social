import { ApiProperty } from '@nestjs/swagger';
import { UserResponse } from './UserResponse';

export class LoginResponse {
  @ApiProperty({ description: 'User information', type: UserResponse })
  user: UserResponse;

  @ApiProperty({ description: 'Access token', type: String })
  accessToken: string;
}
