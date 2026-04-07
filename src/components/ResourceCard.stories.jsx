// src/components/ResourceCard.stories.jsx
import { ResourceCard } from './ResourceCard';

export default {
  title: 'Portfolio/ResourceCard',
  component: ResourceCard,
};

export const Documentation = {
  args: {
    title: 'React Docs',
    image: 'https://cdn.worldvectorlogo.com/logos/react-2.svg',
    summary:
      'The official documentation for React, essential for learning hooks and component lifecycle.',
    link: 'https://react.dev',
  },
};

export const Tooling = {
  args: {
    title: 'Docker Hub',
    image: 'https://cdn.worldvectorlogo.com/logos/docker-3.svg',
    summary:
      'Used for finding official images to containerize the portfolio and other college projects.',
    link: 'https://hub.docker.com',
  },
};
