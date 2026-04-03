-- Add duration_seconds column to sessions table
ALTER TABLE sessions
ADD COLUMN IF NOT EXISTS duration_seconds integer DEFAULT NULL;

-- Add duration_seconds column to workout_history table
ALTER TABLE workout_history
ADD COLUMN IF NOT EXISTS duration_seconds integer DEFAULT NULL;

-- Enable RLS policies for the new column (existing policies cover it automatically
-- since they are row-level, not column-level — no changes needed)
