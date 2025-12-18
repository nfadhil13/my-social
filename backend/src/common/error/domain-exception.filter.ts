import { ArgumentsHost, Catch } from '@nestjs/common';
import { DomainException } from './domain.exception';
import { BaseExceptionFilter } from '@nestjs/core';
import { Request, Response } from 'express';
import { DomainErrorType } from './domain.error';
import { ResponseModel } from '../../model/response.model';

const DOMAIN_TYPE_HTTP_MAP: Record<DomainErrorType, number> = {
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

    res.status(httpStatus).json(<ResponseModel>{
      message: exception.error.code,
      success: false,
      data: null,
    });
  }
}
