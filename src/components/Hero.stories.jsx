// src/components/Hero.stories.jsx
import { Hero } from './Hero';
import { portfolioData } from '../data/portfolioData';

export default {
  title: 'Portfolio/Hero',
  component: Hero,
};

export const Default = {
  args: {
    ...portfolioData.basicInfo,
  },
};
