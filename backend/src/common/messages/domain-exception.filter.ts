import { ArgumentsHost, Catch } from '@nestjs/common';
import { DomainException } from './domain.exception';
import { BaseExceptionFilter } from '@nestjs/core';
import { Request, Response } from 'express';
import { ResponseModel } from '../../model/response.model';
import { getErrorFromDomainException } from '../validation/validation.exception';

@Catch(DomainException)
export class DomainExceptionFilter extends BaseExceptionFilter {
  catch(exception: DomainException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const res = ctx.getResponse<Response>();

    const httpStatus = exception.error.type.value;
    const validationErrors = getErrorFromDomainException(exception);
    res.status(httpStatus).json(<ResponseModel>{
      message: exception.error.code,
      success: false,
      errors: validationErrors,
      data: null,
    });
  }
}
