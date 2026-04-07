// src/components/SkillGroup.stories.jsx
import { SkillGroup } from './SkillGroup';

export default {
  title: 'Portfolio/SkillGroup',
  component: SkillGroup,
};

export const Languages = {
  args: {
    title: 'Languages & Frameworks',
    skills: ['JavaScript', 'React', 'Node.js', 'Python', 'Java'],
  },
};

export const Tools = {
  args: {
    title: 'Tools & DevOps',
    skills: ['Docker', 'Git', 'VS Code', 'Vite', 'Nginx'],
  },
};
