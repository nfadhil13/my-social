import { ValidationException } from './validation.exception';
import { z } from 'zod';
import { ZodValidationPipe } from './validation.pipe';

describe('ValidationPipe', () => {
  const messages = {
    name: {
      min: 'Name must be at least 1 character',
    },
    age: {
      min: 'Age must be greater than 18',
    },
    profile: {
      bio: {
        min: 'Bio must be at least 1 character',
      },
      avatar_file_id: {
        min: 'Avatar file ID must be at least 1 character',
      },
    },
  };

  let pipe: ZodValidationPipe;

  const schemaExample = z.object({
    name: z.string().min(1, messages.name.min),
    age: z.number().min(18, messages.age.min),
    profile: z.object({
      bio: z.string().min(1, messages.profile.bio.min),
      avatar_file_id: z.string().min(1, messages.profile.avatar_file_id.min),
    }),
  });

  beforeEach(() => {
    pipe = new ZodValidationPipe(schemaExample);
  });

  it('should return the parsed value if the value is valid', () => {
    const value = {
      name: 'John',
      age: 20,
      profile: { bio: 'Hello', avatar_file_id: '123' },
    };
    const result = pipe.transform(value);
    expect(result).toEqual(value);
  });

  it('should throw a BadRequestException if the value is invalid', () => {
    const value = {
      name: '',
      age: 10,
      profile: { bio: '', avatar_file_id: '' },
    };
    try {
      pipe.transform(value);
      fail('Expected a BadRequestException to be thrown');
    } catch (error) {
      expect(error).toBeInstanceOf(ValidationException);
      if (!(error instanceof ValidationException)) {
        fail('Expected a BadRequestException to be thrown');
      }
      expect(error.error.code).toBe(DomainMessageTypes.VALIDATION.key);
      expect(error.errors?.['name']?.[0]?.code).toBe(messages.name.min);
      expect(error.errors?.['age']?.[0]?.code).toBe(messages.age.min);
      expect(error.errors?.['profile.bio']?.[0]?.code).toBe(
        messages.profile.bio.min,
      );
      expect(error.errors?.['profile.avatar_file_id']?.[0]?.code).toBe(
        messages.profile.avatar_file_id.min,
      );
    }
  });
});
