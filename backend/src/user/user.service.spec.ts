import { Test, TestingModule } from '@nestjs/testing';
import { UserService } from './user.service';
import { DeepMockProxy, mockDeep } from 'jest-mock-extended';
import { PrismaService } from '../common/prisma/prisma.service';
import { RegisterRequest } from '../auth/dto/request/RegisterRequest';
import { DomainException } from '../common/messages/domain.exception';
import { USER_ERRORS } from './user.messages';

describe('UserService', () => {
  let service: UserService;
  let prismaService: DeepMockProxy<PrismaService>;

  beforeEach(async () => {
    prismaService = mockDeep<PrismaService>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserService,
        {
          provide: PrismaService,
          useValue: prismaService,
        },
      ],
    }).compile();

    service = module.get<UserService>(UserService);
  });

  describe('createUser', () => {
    it('should create a new user', async () => {
      const userId = '123';
      const registerDto: RegisterRequest = {
        email: 'test@test.com',
        password: 'test123',
        name: 'test',
        username: 'test',
      };
      prismaService.user.findFirst.mockResolvedValue(null);
      prismaService.user.create.mockResolvedValue({
        id: userId,
        username: registerDto.username,
        email: registerDto.email,
        password_hash: 'test123',
        role: 'USER',
        created_at: new Date(),
        updated_at: new Date(),
      });
      const user = await service.createUser(registerDto);
      expect(user).toBeDefined();
      expect(user.id).toBe(userId);
    });

    it('should throw an error if the email already exists', async () => {
      const registerDto: RegisterRequest = {
        email: 'test@test.com',
        password: 'test123',
        name: 'test',
        username: 'test',
      };
      prismaService.user.findFirst.mockResolvedValue({
        id: '123',
        email: registerDto.email,
        password_hash: 'test123',
        role: 'USER',
        username: 'USERNAME',
        created_at: new Date(),
        updated_at: new Date(),
      });
      try {
        await service.createUser(registerDto);
      } catch (error) {
        expect(error).toBeInstanceOf(DomainException);
        expect((error as DomainException).error).toBe(
          USER_ERRORS.EMAIL_ALREADY_EXISTS,
        );
      }
    });

    it('should throw an error if the username already exists', async () => {
      const registerDto: RegisterRequest = {
        email: 'test@test.com',
        password: 'test123',
        name: 'test',
        username: 'test',
      };
      prismaService.user.findFirst.mockResolvedValue({
        id: '123',
        email: 'other@test.com',
        password_hash: 'test123',
        role: 'USER',
        username: registerDto.username,
        created_at: new Date(),
        updated_at: new Date(),
      });
      try {
        await service.createUser(registerDto);
      } catch (error) {
        expect(error).toBeInstanceOf(DomainException);
        expect((error as DomainException).error).toBe(
          USER_ERRORS.USERNAME_ALREADY_EXISTS,
        );
      }
    });
  });

  describe('findByEmail', () => {
    it('should find a user by email', async () => {
      const email = 'test@test.com';
      prismaService.user.findUnique.mockResolvedValue({
        id: '123',
        email: email,
        password_hash: 'hashedPassword',
        role: 'USER',
        username: 'test',
        created_at: new Date(),
        updated_at: new Date(),
      });
      const user = await service.findByEmail(email);
      expect(user).toBeDefined();
      expect(user?.email).toBe(email);
      expect(user?.id).toBe('123');
    });

    it('should return null if user does not exist', async () => {
      const email = 'test@test.com';
      prismaService.user.findUnique.mockResolvedValue(null);
      const user = await service.findByEmail(email);
      expect(user).toBeNull();
    });
  });
});
