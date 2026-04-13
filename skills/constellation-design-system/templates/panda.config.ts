import { constellationPandaConfig } from '@zillow/constellation-config';

export default constellationPandaConfig({
  config: {
    include: ['./src/**/*.{ts,tsx,js,jsx}'],
    outdir: 'styled-system',
    staticCss: {
      themes: ['zillow'],
    },
  },
});
