import { Injectable } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { type RegisterRequest } from './dto/request/RegisterRequest';
import { AUTH_ERRORS } from './auth.messages';
import { DomainException } from '../common/messages/domain.exception';
import { UserService } from '../user/user.service';
import { LoginResponse } from './dto/response/LoginResponse';
import { LoginRequest } from './dto/request/LoginRequest';
import { UserResponse } from './dto/response/UserResponse';

@Injectable()
export class AuthService {
  constructor(
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
  ) {}

  async register(registerDto: RegisterRequest): Promise<UserResponse> {
    console.log('registerDto', registerDto);
    return this.userService.createUser(registerDto);
  }

  async login(loginDto: LoginRequest): Promise<LoginResponse> {
    const user = await this.userService.findByEmail(loginDto.email);
    console.log('user', user);
    if (!user) throw new DomainException(AUTH_ERRORS.INVALID_CREDENTIALS);
    const isPasswordValid = await bcrypt.compare(
      loginDto.password,
      user.password_hash,
    );
    console.log('isPasswordValid', isPasswordValid);
    if (!isPasswordValid) {
      throw new DomainException(AUTH_ERRORS.INVALID_CREDENTIALS);
    }
    const accessToken = await this.jwtService.signAsync(
      { userId: user.id },
      { expiresIn: '1h' },
    );
    return {
      user: {
        id: user.id,
        email: user.email,
        username: user.username,
        role: user.role,
      },
      accessToken,
    };
  }
}
