// src/components/ProjectCard.stories.jsx
import { ProjectCard } from './ProjectCard';
import { portfolioData } from '../data/portfolioData';

export default {
  title: 'Portfolio/ProjectCard',
  component: ProjectCard,
};

export const SingleProject = {
  args: {
    ...portfolioData.projects[0],
  },
};

export const ManyTechnologies = {
  args: {
    ...portfolioData.projects[0],
    techList: ['React', 'Vite', 'Docker', 'Playwright', 'Node', 'Sass', 'Framer Motion'],
  },
};
