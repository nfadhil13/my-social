export enum DomainErrorType {
  NOT_FOUND = 'NOT_FOUND',
  CONFLICT = 'CONFLICT',
  UNAUTHORIZED = 'UNAUTHORIZED',
  FORBIDDEN = 'FORBIDDEN',
  VALIDATION = 'VALIDATION',
  INTERNAL = 'INTERNAL',
}

export interface DomainErrorDefinition {
  code: string;
  type: DomainErrorType;
}
