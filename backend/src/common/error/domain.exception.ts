import { DomainErrorDefinition } from './domain.error';

export class DomainException extends Error {
  constructor(
    public readonly error: DomainErrorDefinition,
    public readonly meta?: Record<string, any>,
  ) {
    super(error.code);
  }
}
