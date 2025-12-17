import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { DeepMockProxy, mockDeep } from 'jest-mock-extended';
import { PrismaService } from '../common/prisma/prisma.service';
import { RegisterDto } from '../model/user/register.model';
import { ConflictException, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { type LoginDto } from '../model/user/login.model';

describe('AuthService', () => {
  let service: AuthService;
  let jwtService: DeepMockProxy<JwtService>;
  let prismaService: DeepMockProxy<PrismaService>;

  beforeEach(async () => {
    prismaService = mockDeep<PrismaService>();
    jwtService = mockDeep<JwtService>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: PrismaService,
          useValue: prismaService,
        },
        {
          provide: JwtService,
          useValue: jwtService,
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
        name: 'test',
        username: 'test',
      };
      prismaService.user.findUnique.mockResolvedValue(null);
      prismaService.user.create.mockResolvedValue({
        id: userId,
        username: registerDto.username,
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
        name: 'test',
        username: 'test',
      };
      prismaService.user.findUnique.mockResolvedValue({
        id: '123',
        email: registerDto.email,
        password_hash: 'test123',
        role: 'USER',
        username: registerDto.username,
        created_at: new Date(),
        updated_at: new Date(),
      });
      try {
        await service.register(registerDto);
      } catch (error) {
        expect(error).toBeInstanceOf(ConflictException);
        expect((error as ConflictException).message).toBe(
          'Email or Username already exists',
        );
      }
    });
  });

  describe('login', () => {
    it('should login a user', async () => {
      const accessToken = 'ACCESS_TOKEN';
      const loginDto: LoginDto = {
        email: 'test@test.com',
        password: 'test123',
      };
      const hashedPassword = await bcrypt.hash('test123', 10);
      prismaService.user.findUnique.mockResolvedValue({
        id: '123',
        email: loginDto.email,
        password_hash: hashedPassword,
        role: 'USER',
        username: 'test',
        created_at: new Date(),
        updated_at: new Date(),
      });
      jwtService.signAsync.mockResolvedValue(accessToken);
      const user = await service.login(loginDto);
      expect(user).toBeDefined();
      expect(user.user.id).toBe('123');
      expect(user.user.email).toBe(loginDto.email);
      expect(user.user.role).toBe('USER');
      expect(user.accessToken).toBe(accessToken);
    });

    it('should throw an error if the user does not exist', async () => {
      const loginDto: LoginDto = {
        email: 'test@test.com',
        password: 'test123',
      };
      prismaService.user.findUnique.mockResolvedValue(null);
      try {
        await service.login(loginDto);
      } catch (error) {
        expect(error).toBeInstanceOf(UnauthorizedException);
        expect((error as UnauthorizedException).message).toBe(
          'Username or Password is incorrect',
        );
      }
    });

    it('should throw an error if the password is incorrect', async () => {
      const loginDto: LoginDto = {
        email: 'test@test.com',
        password: 'test123',
      };
      prismaService.user.findUnique.mockResolvedValue({
        id: '123',
        email: loginDto.email,
        password_hash: 'test123',
        role: 'USER',
        username: 'test',
        created_at: new Date(),
        updated_at: new Date(),
      });
      try {
        await service.login(loginDto);
      } catch (error) {
        expect(error).toBeInstanceOf(UnauthorizedException);
        expect((error as UnauthorizedException).message).toBe(
          'Username or Password is incorrect',
        );
      }
    });
  });
});
