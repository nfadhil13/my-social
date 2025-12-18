import { Injectable } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../common/prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import { type RegisterDto } from '../model/user/register.model';
import { LoginResponse, type LoginDto } from '../model/user/login.model';
import { UserWhereUniqueInput } from '../common/prisma/client/models/User';
import { AUTH_ERRORS } from './auth.messages';
import { DomainException } from '../common/messages/domain.exception';

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwtService: JwtService,
  ) {}

  async register(registerDto: RegisterDto): Promise<string> {
    const existingUser = await this.prisma.user.findFirst({
      where: <UserWhereUniqueInput>{
        OR: [
          {
            email: registerDto.email,
          },
          {
            username: registerDto.username,
          },
        ],
      },
      select: {
        email: true,
        username: true,
      },
    });

    if (existingUser) {
      if (existingUser.email === registerDto.email) {
        throw new DomainException(AUTH_ERRORS.EMAIL_ALREADY_EXISTS);
      }
      if (existingUser.username === registerDto.username) {
        throw new DomainException(AUTH_ERRORS.USERNAME_ALREADY_EXISTS);
      }
    }
    const { password, ...register } = registerDto;
    const passwordHash = await bcrypt.hash(password, 10);
    const user = await this.prisma.user.create({
      data: {
        email: register.email,
        username: register.username,
        password_hash: passwordHash,
        profile: {
          create: {
            name: register.name,
            bio: null,
            avatar_file_id: null,
            thumbnail_file_id: null,
          },
        },
      },
    });
    return user.id;
  }

  async login(loginDto: LoginDto): Promise<LoginResponse> {
    const user = await this.prisma.user.findUnique({
      where: {
        email: loginDto.email,
      },
      select: {
        id: true,
        email: true,
        password_hash: true,
        username: true,
        role: true,
      } as const,
    });
    if (!user) throw new DomainException(AUTH_ERRORS.INVALID_CREDENTIALS);
    const isPasswordValid = await bcrypt.compare(
      loginDto.password,
      user.password_hash,
    );
    if (!isPasswordValid) {
      throw new DomainException(AUTH_ERRORS.INVALID_CREDENTIALS);
    }
    const accessToken = await this.jwtService.signAsync({ userId: user.id });
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { password_hash, ...userWithoutPassword } = user;
    return { user: userWithoutPassword, accessToken };
  }
}
