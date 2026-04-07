// src/data/portfolioData.js
const dockerBaseUrl = 'http://127.0.0.1:5575';
const assetBaseUrl = import.meta.env.DEV ? dockerBaseUrl : '';

export const portfolioData = {
  basicInfo: {
    name: 'Zack de Boer',
    title: 'Full Stack Developer',
    bio: 'Student at Red River Polytechnic focused on React and LAMP stack CMS development.',
  },
  projects: [
    {
      title: 'Static Site for Ladybug Cleaning Services',
      description: 'My final project for term 1 - Web Development 1.',
      image: `${assetBaseUrl}/ladybug/images/ladybugsite_image.png`,
      link: `${assetBaseUrl}/ladybug/`,
      techList: ['HTML', 'CSS'],
    },
    {
      title: '8-Track Playlist Organizer',
      description:
        'A PHP application for organizing playlists, which makes use of a CMS using a LAMP stack, and the Spotify Web API',
      image: `${assetBaseUrl}/8-track/images/8_track_logo.jpg`,
      link: `${assetBaseUrl}/8-track/`,
      techList: ['PHP', 'CSS', 'LAMP Stack', 'CMS', 'API', 'Spotify'],
    },
  ],
  skills: {
    languages: ['JavaScript', 'HTML', 'CSS', 'Ruby', 'PHP', 'SQL', 'UNIX'],
    tools: ['Git', 'Vite', 'Docker', 'Ruby on Rails'],
  },
  resources: [
    {
      title: 'Vite Docs',
      image: 'https://vitejs.dev/logo.svg',
      summary: 'Used for the build system.',
      link: 'https://vitejs.dev',
    },
  ],
  setup: {
    editor: 'VS Code',
    terminal: 'Bash',
    font: 'Fira Code',
  },
};
