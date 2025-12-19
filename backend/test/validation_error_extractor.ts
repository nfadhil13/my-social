import { ValidationIssue } from '../src/common/validation/validation.exception';

export const extractValidationErrors = (
  errors: Record<string, any>,
  key: string,
): ValidationIssue[] | undefined => {
  const error: unknown = errors?.[key];
  if (!error) return undefined;
  if (!Array.isArray(error)) return undefined;
  return error as ValidationIssue[];
};
