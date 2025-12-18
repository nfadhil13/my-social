import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { DeepMockProxy, mockDeep } from 'jest-mock-extended';
import { RegisterDto } from '../model/user/register.model';
import { ConflictException } from '@nestjs/common';
import { LoginDto, LoginResponse } from '../model/user/login.model';

describe('AuthController', () => {
  let authService: DeepMockProxy<AuthService>;
  let controller: AuthController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [
        {
          provide: AuthService,
          useValue: mockDeep<AuthService>(),
        },
      ],
    }).compile();
    authService = module.get<DeepMockProxy<AuthService>>(AuthService);
    controller = module.get<AuthController>(AuthController);
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
      authService.register.mockResolvedValue(userId);
      expect(await controller.register(registerDto)).toEqual({
        message: 'USER_REGISTERED_SUCCESSFULLY',
        data: userId,
        success: true,
      });
    });
    it('should throw an error if the user already exists', async () => {
      const registerDto: RegisterDto = {
        email: 'test@test.com',
        password: 'test123',
        name: 'test',
        username: 'test',
      };
      authService.register.mockRejectedValue(
        new ConflictException('Email already exists'),
      );
      try {
        await controller.register(registerDto);
      } catch (error) {
        expect(error).toBeDefined();
        if (!(error instanceof ConflictException)) {
          fail('Error is not a ConflictException');
        }
        expect(error.message).toBe('Email already exists');
      }
    });
  });

  describe('login', () => {
    it('should login a user', async () => {
      const userId = '123';
      const accessToken = 'ACCESS_TOKEN';
      const loginDto: LoginDto = {
        email: 'test@test.com',
        password: 'P@ssw0rd41',
      };
      authService.login.mockResolvedValue(<LoginResponse>{
        user: {
          email: 'test@test.com',
          username: 'test',
          name: 'test',
          id: userId,
          role: 'USER',
        },
        accessToken: accessToken,
      });
      const result = await controller.login(loginDto);
      expect(result.data.user.id).toBe(userId);
      expect(result.data.accessToken).toBe(accessToken);
    });
  });
});
