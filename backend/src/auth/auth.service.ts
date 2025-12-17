import {
  ConflictException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../common/prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import { type RegisterDto } from '../model/user/register.model';
import { LoginResponse, type LoginDto } from '../model/user/login.model';
import { type UserWhereUniqueInput } from '../common/prisma/client/models';

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwtService: JwtService,
  ) {}

  async register(registerDto: RegisterDto): Promise<string> {
    const existingUser = await this.prisma.user.findUnique({
      where: {
        OR: [
          {
            email: {
              equals: registerDto.email,
            },
          },
          {
            username: {
              equals: registerDto.username,
            },
          },
        ],
      } as UserWhereUniqueInput,
    });
    if (existingUser) {
      throw new ConflictException('Email or Username already exists');
    }
    const { password, ...register } = registerDto;
    const passwordHash = await bcrypt.hash(password, 10);
    const user = await this.prisma.user.create({
      data: {
        ...register,
        password_hash: passwordHash,
        profile: {
          create: {
            name: registerDto.name,
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
    });
    if (!user)
      throw new UnauthorizedException('Username or Password is incorrect');
    const isPasswordValid = await bcrypt.compare(
      loginDto.password,
      user.password_hash,
    );
    if (!isPasswordValid) {
      throw new UnauthorizedException('Username or Password is incorrect');
    }
    const accessToken = await this.jwtService.signAsync({ userId: user.id });
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { password_hash, ...userWithoutPassword } = user;
    return { user: userWithoutPassword, accessToken };
  }
}
