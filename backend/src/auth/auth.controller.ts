import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthValidation } from 'src/model/user/auth.validation';
import type { RegisterDto } from 'src/model/user/register.model';
import { ZodValidationPipe } from 'src/common/validation/validation.pipe';
import { ResponseModel } from 'src/model/response.model';

@Controller('')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  async register(
    @Body(new ZodValidationPipe(AuthValidation.REGISTER))
    registerDto: RegisterDto,
  ): Promise<ResponseModel<string>> {
    return this.authService
      .register(registerDto)
      .toSuccessResponse('USER_REGISTERED_SUCCESSFULLY');
  }
}
