import { Role } from '../../common/prisma/client/enums';

export type UserResponse = {
  id: string;
  email: string;
  username: string;
  role: Role;
};
