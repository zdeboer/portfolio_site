// src/App.jsx
import './index.css';
import { portfolioData } from './data/portfolioData';

// Import your components
import { Hero } from './components/Hero';
import { ProjectCard } from './components/ProjectCard';
import { SkillGroup } from './components/SkillGroup';
import { ResourceCard } from './components/ResourceCard';
import { SetupSection } from './components/SetupSection';

function App() {
  // Safety Destructuring: If portfolioData or any sub-object is missing,
  // it defaults to empty objects/arrays to prevent "Cannot read property of undefined"
  const {
    basicInfo = {},
    projects = [],
    skills = { languages: [], tools: [] },
    resources = [],
    setup = {},
  } = portfolioData || {};

  return (
    <div className="container">
      {/* 1. Basic Information Section */}
      <section id="about">
        <Hero
          name={basicInfo.name || 'Name Not Set'}
          title={basicInfo.title || 'Developer'}
          bio={basicInfo.bio || 'Bio coming soon...'}
        />
      </section>

      <hr className="section-divider" />

      {/* 2. Work Section */}
      <section id="work">
        <h2 className="section-title">Selected Work</h2>
        <div className="projects-grid">
          {projects.length > 0 ? (
            projects.map((project, index) => <ProjectCard key={`project-${index}`} {...project} />)
          ) : (
            <p>No projects listed yet.</p>
          )}
        </div>
      </section>

      {/* 3. Skills Section */}
      <section id="skills">
        <h2 className="section-title">Technical Skills</h2>
        <div className="skills-grid" style={{ display: 'flex', gap: '2rem', flexWrap: 'wrap' }}>
          <SkillGroup title="Languages & Frameworks" skills={skills.languages || []} />
          <SkillGroup title="Tools & Environment" skills={skills.tools || []} />
        </div>
      </section>

      {/* 4. Resources Section */}
      <section id="resources">
        <h2 className="section-title">Learning Resources</h2>
        <div className="projects-grid">
          {resources.length > 0 ? (
            resources.map((res, index) => <ResourceCard key={`res-${index}`} {...res} />)
          ) : (
            <p>No resources added.</p>
          )}
        </div>
      </section>

      {/* 5. Developer Setup Section */}
      <section id="setup">
        <h2 className="section-title">Developer Setup</h2>
        <SetupSection
          editor={setup.editor || 'Not specified'}
          terminal={setup.terminal || 'Not specified'}
          font={setup.font || 'Not specified'}
        />
      </section>

      <footer className="footer">
        <p>© 2026 {basicInfo.name || 'Developer'} | Assignment 14 Portfolio</p>
      </footer>
    </div>
  );
}

export default App;
