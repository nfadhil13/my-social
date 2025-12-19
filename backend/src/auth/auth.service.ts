import { Injectable } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { type RegisterDto } from './dto/register.dto';
import { LoginResponse, type LoginDto } from './dto/login.dto';
import { AUTH_ERRORS } from './auth.messages';
import { DomainException } from '../common/messages/domain.exception';
import { UserService } from '../user/user.service';

@Injectable()
export class AuthService {
  constructor(
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
  ) {}

  async register(registerDto: RegisterDto): Promise<string> {
    return this.userService.createUser(registerDto);
  }

  async login(loginDto: LoginDto): Promise<LoginResponse> {
    const user = await this.userService.findByEmail(loginDto.email);
    if (!user) throw new DomainException(AUTH_ERRORS.INVALID_CREDENTIALS);
    const isPasswordValid = await bcrypt.compare(
      loginDto.password,
      user.password_hash,
    );
    if (!isPasswordValid) {
      throw new DomainException(AUTH_ERRORS.INVALID_CREDENTIALS);
    }
    const accessToken = await this.jwtService.signAsync({ userId: user.id });
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
