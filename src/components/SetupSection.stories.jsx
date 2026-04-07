// src/components/SetupSection.stories.jsx
import { SetupSection } from './SetupSection';
import { portfolioData } from '../data/portfolioData';

export default {
  title: 'Portfolio/SetupSection',
  component: SetupSection,
};

export const Default = {
  args: {
    ...portfolioData.setup
  },
};