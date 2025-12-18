import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthValidation } from '../model/user/auth.validation';
import type { RegisterDto } from '../model/user/register.model';
import { ResponseModel } from '../model/response.model';
import { ZodValidationPipe } from '../common/validation/validation.pipe';
import { type LoginResponse, type LoginDto } from '../model/user/login.model';

@Controller('')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  async register(
    @Body(new ZodValidationPipe(AuthValidation.REGISTER))
    registerDto: RegisterDto,
  ): Promise<ResponseModel<string>> {
    return await this.authService
      .register(registerDto)
      .toSuccessResponse('USER_REGISTERED_SUCCESSFULLY');
  }

  @Post('login')
  async login(
    @Body(new ZodValidationPipe(AuthValidation.LOGIN))
    loginDto: LoginDto,
  ): Promise<ResponseModel<LoginResponse>> {
    return await this.authService
      .login(loginDto)
      .toSuccessResponse('USER_LOGGED_IN_SUCCESSFULLY');
  }
}
