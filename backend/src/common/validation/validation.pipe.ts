import { PipeTransform } from '@nestjs/common';
import { ZodType, ZodError } from 'zod';
import { ValidationException } from './validation.exception';

export class ValidationPipe implements PipeTransform {
  constructor(private readonly schema: ZodType) {}
  transform(value: any) {
    try {
      const parsedValue = this.schema.parse(value);
      return parsedValue;
    } catch (error) {
      if (error instanceof ZodError) {
        throw new ValidationException(error);
      }
      throw error;
    }
  }
}
