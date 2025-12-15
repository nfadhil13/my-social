import { ZodValidationPipe } from './validation.pipe';
import { z } from 'zod';
import { ValidationException } from './validation.exception';

describe('ValidationPipe', () => {
  let pipe: ZodValidationPipe;

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
      const response = error.getResponse() as Record<string, string>;
      expect(response['message']).toBe(ValidationException.MESSAGE);
      expect(response['errors']).toEqual({
        name: messages.name.min,
        age: messages.age.min,
        'profile.bio': messages.profile.bio.min,
        'profile.avatar_file_id': messages.profile.avatar_file_id.min,
      });
    }
  });
});
