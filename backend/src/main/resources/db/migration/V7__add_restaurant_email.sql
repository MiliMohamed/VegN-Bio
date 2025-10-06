-- Add email column to restaurants table
ALTER TABLE restaurants ADD COLUMN email VARCHAR(255);

-- Update existing restaurants with default email
UPDATE restaurants SET email = 'contact@restaurant' || id || '.com' WHERE email IS NULL;
