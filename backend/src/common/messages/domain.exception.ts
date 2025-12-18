import { DomainMessage } from './domain.messages';

export class DomainException extends Error {
  constructor(
    public readonly error: DomainMessage,
    public readonly meta?: Record<string, any>,
  ) {
    super(error.code);
  }
}
