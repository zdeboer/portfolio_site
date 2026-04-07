// src/components/Hero.stories.jsx
import { Hero } from './Hero';
import { portfolioData } from '../data/portfolioData';

export default {
  title: 'Portfolio/Hero',
  component: Hero,
};

// src/components/Hero.stories.jsx
export const Professional = {
  args: {
    name: 'Alex Smith',
    title: 'Full Stack Developer & DevOps Enthusiast',
    bio: 'Specializing in React ecosystems and automated CI/CD pipelines. Currently finishing my final semester with a focus on containerization.',
    avatarUrl: 'https://i.pravatar.cc/300', // Just for the story!
  },
};

export const Default = {
  args: {
    ...portfolioData.basicInfo,
  },
};
