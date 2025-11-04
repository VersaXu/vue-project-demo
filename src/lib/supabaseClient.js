import { createClient } from '@supabase/supabase-js'

export const supabase = createClient(
  'https://nvfmycmgvtmaupsbxwqg.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im52Zm15Y21ndnRtYXVwc2J4d3FnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkwMDQxNDgsImV4cCI6MjA1NDU4MDE0OH0.O6Fsphd4Zo2Ipy1dELGg3wFvvv9lZWuweP91KczTZB0',
)
