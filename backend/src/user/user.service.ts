import { Injectable } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../common/prisma/prisma.service';
import { type RegisterDto } from '../auth/dto/register.dto';
import { UserWhereUniqueInput } from '../common/prisma/client/models/User';
import { DomainException } from '../common/messages/domain.exception';
import { USER_ERRORS } from './user.messages';

@Injectable()
export class UserService {
  constructor(private readonly prisma: PrismaService) {}

  async createUser(registerDto: RegisterDto): Promise<string> {
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
        throw new DomainException(USER_ERRORS.EMAIL_ALREADY_EXISTS);
      }
      if (existingUser.username === registerDto.username) {
        throw new DomainException(USER_ERRORS.USERNAME_ALREADY_EXISTS);
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
      select: {
        id: true,
      },
    });
    return user.id;
  }

  async findByEmail(email: string) {
    return this.prisma.user.findUnique({
      where: {
        email,
      },
      select: {
        id: true,
        email: true,
        password_hash: true,
        username: true,
        role: true,
      } as const,
    });
  }
}
