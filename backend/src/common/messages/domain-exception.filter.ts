import { ArgumentsHost, Catch } from '@nestjs/common';
import { DomainException } from './domain.exception';
import { BaseExceptionFilter } from '@nestjs/core';
import { Request, Response } from 'express';
import { DomainMessageType } from './domain.messages';
import { ResponseModel } from '../../model/response.model';
import { getErrorFromDomainException } from '../validation/validation.exception';

const DOMAIN_TYPE_HTTP_MAP: Record<DomainMessageType, number> = {
  SUCCESS: 200,
  NOT_FOUND: 404,
  CONFLICT: 409,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  VALIDATION: 400,
  INTERNAL: 500,
};

@Catch(DomainException)
export class DomainExceptionFilter extends BaseExceptionFilter {
  catch(exception: DomainException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const res = ctx.getResponse<Response>();

    const httpStatus = DOMAIN_TYPE_HTTP_MAP[exception.error.type] ?? 500;
    const validationErrors = getErrorFromDomainException(exception);
    res.status(httpStatus).json(<ResponseModel>{
      message: exception.error.code,
      success: false,
      errors: validationErrors,
      data: null,
    });
  }
}
