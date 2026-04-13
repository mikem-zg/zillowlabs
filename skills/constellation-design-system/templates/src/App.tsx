import { Spinner, Box, Heading } from '@zillow/constellation';

function App() {
  return (
    <Box
      css={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        minHeight: '100vh',
        gap: 'layout.looser',
      }}
    >
      <img
        src={`${import.meta.env.BASE_URL}Replit-Logo-Primary.svg`}
        alt="Replit"
        style={{ width: 300, height: 'auto' }}
      />
      <Box css={{ display: 'flex', alignItems: 'center', gap: 'layout.default' }}>
        <Spinner />
        <Heading level={4}>Replit agent working</Heading>
      </Box>
    </Box>
  );
}

export default App;
