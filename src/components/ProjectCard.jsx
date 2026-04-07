// src/components/ProjectCard.jsx
export const ProjectCard = ({ title, description, image, link, techList }) => (
  <div className="project-card">
    <img src={image} alt={title} className="project-img" />
    <div className="project-content">
      <h3>{title}</h3>
      <p>{description}</p>
      <div className="tech-stack">
        {techList.map(tech => <span key={tech} className="badge">{tech}</span>)}
      </div>
      <a href={link} className="project-link">View Project</a>
    </div>
  </div>
);