-- AlterTable
ALTER TABLE "profiles" ALTER COLUMN "bio" DROP NOT NULL,
ALTER COLUMN "avatar_file_id" DROP NOT NULL,
ALTER COLUMN "thumbnail_file_id" DROP NOT NULL;
