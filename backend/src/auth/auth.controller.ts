import { Body, Controller, HttpCode, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthValidation } from './dto/auth.validation';
import type { RegisterDto } from './dto/register.dto';
import { ResponseModel, successResponse } from '../model/response.model';
import { ZodValidationPipe } from '../common/validation/validation.pipe';
import { type LoginResponse, type LoginDto } from './dto/login.dto';
import { AUTH_MESSAGES } from './auth.messages';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  async register(
    @Body(new ZodValidationPipe(AuthValidation.REGISTER))
    registerDto: RegisterDto,
  ): Promise<ResponseModel<string>> {
    const userId = await this.authService.register(registerDto);
    return successResponse(userId, AUTH_MESSAGES.USER_REGISTERED_SUCCESSFULLY);
  }

  @Post('login')
  @HttpCode(200)
  async login(
    @Body(new ZodValidationPipe(AuthValidation.LOGIN))
    loginDto: LoginDto,
  ): Promise<ResponseModel<LoginResponse>> {
    const result = await this.authService.login(loginDto);
    return successResponse(result, AUTH_MESSAGES.USER_LOGGED_IN_SUCCESSFULLY);
  }
}
