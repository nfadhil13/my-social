import { Body, Controller, HttpCode, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthValidation } from './dto/auth.validation';
import { RegisterRequest } from './dto/request/RegisterRequest';
import {
  ApiOkResponseCustom,
  ResponseModel,
  successResponse,
} from '../model/response.model';
import { ZodValidationPipe } from '../common/validation/validation.pipe';
import { AUTH_MESSAGES } from './auth.messages';
import { ApiBody, ApiOperation } from '@nestjs/swagger';
import { LoginRequest } from './dto/request/LoginRequest';
import { LoginResponse } from './dto/response/LoginResponse';
import { RegisterResponse } from './dto/response/RegisterResponse';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  @ApiBody({ type: RegisterRequest })
  @ApiOkResponseCustom(RegisterResponse)
  @ApiOperation({ summary: 'Register a new user' })
  async register(
    @Body(new ZodValidationPipe(AuthValidation.REGISTER))
    registerDto: RegisterRequest,
  ): Promise<ResponseModel<RegisterResponse>> {
    const userId = await this.authService.register(registerDto);
    return successResponse(
      { id: userId.id, email: userId.email },
      AUTH_MESSAGES.USER_REGISTERED_SUCCESSFULLY,
    );
  }

  @Post('login')
  @ApiOperation({ summary: 'Register a new user' })
  @ApiBody({ type: LoginRequest })
  @ApiOkResponseCustom(LoginResponse)
  @HttpCode(200)
  async login(
    @Body(new ZodValidationPipe(AuthValidation.LOGIN))
    loginDto: LoginRequest,
  ): Promise<ResponseModel<LoginResponse>> {
    const result = await this.authService.login(loginDto);
    return successResponse(result, AUTH_MESSAGES.USER_LOGGED_IN_SUCCESSFULLY);
  }
}
