import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../src/common/prisma/prisma.service';
import { Profile, User } from '../../src/common/prisma/client/client';

@Injectable()
export class AuthTestService {
  constructor(private readonly prisma: PrismaService) {}

  async deleteAllUsers(): Promise<void> {
    await this.prisma.profile.deleteMany();
    await this.prisma.user.deleteMany();
  }

  async createUser(user: User, profile: Profile): Promise<void> {
    await this.prisma.user.create({
      data: {
        ...user,
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
