// Set NODE_ENV to fallback to 'development'.
process.env.NODE_ENV ??= 'development';

import { createColors } from 'colorette';
import { config } from 'dotenv-defaults';

// Setup dotenv
config();

// Enable colorette
createColors({ useColor: true });
