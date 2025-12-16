import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { DeepMockProxy, mockDeep } from 'jest-mock-extended';
import { PrismaService } from '../common/prisma/prisma.service';
import { RegisterDto } from '../model/user/register.model';
import { ConflictException } from '@nestjs/common';

describe('AuthService', () => {
  let service: AuthService;
  let prismaService: DeepMockProxy<PrismaService>;

  beforeEach(async () => {
    prismaService = mockDeep<PrismaService>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: PrismaService,
          useValue: prismaService,
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  describe('register', () => {
    it('should register a new user', async () => {
      const userId = '123';
      const registerDto: RegisterDto = {
        email: 'test@test.com',
        password: 'test123',
      };
      prismaService.user.findUnique.mockResolvedValue(null);
      prismaService.user.create.mockResolvedValue({
        id: userId,
        email: registerDto.email,
        password_hash: 'test123',
        role: 'USER',
        created_at: new Date(),
        updated_at: new Date(),
      });
      const user = await service.register(registerDto);
      expect(user).toBeDefined();
      expect(user).toBe(userId);
    });

    it('should throw an error if the user already exists', async () => {
      const registerDto: RegisterDto = {
        email: 'test@test.com',
        password: 'test123',
      };
      prismaService.user.findUnique.mockResolvedValue({
        id: '123',
        email: registerDto.email,
        password_hash: 'test123',
        role: 'USER',
        created_at: new Date(),
        updated_at: new Date(),
      });
      try {
        await service.register(registerDto);
      } catch (error) {
        expect(error).toBeInstanceOf(ConflictException);
        expect((error as ConflictException).message).toBe(
          'Email already exists',
        );
      }
    });
  });
});
