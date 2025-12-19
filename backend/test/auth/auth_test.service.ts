import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../src/common/prisma/prisma.service';
import { Profile, User } from '../../src/common/prisma/client/client';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthTestService {
  constructor(private readonly prisma: PrismaService) {}

  async deleteAllUsers(): Promise<void> {
    await this.prisma.profile.deleteMany();
    await this.prisma.user.deleteMany();
  }

  async createUser(user: User, profile: Profile): Promise<void> {
    const { password_hash, ...userData } = user;
    const passwordHash = await bcrypt.hash(password_hash, 10);
    await this.prisma.user.create({
      data: {
        ...userData,
        password_hash: passwordHash,
        profile: {
          create: {
            ...profile,
          },
        },
      },
      include: {
        profile: true,
      },
    });
  }

  async deleteUser(id: string): Promise<void> {
    await this.prisma.user.delete({
      where: {
        id,
      },
    });
  }
}
