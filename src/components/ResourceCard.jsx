// src/components/ResourceCard.jsx
export const ResourceCard = ({ title, summary, image, link }) => (
  <div className="project-card">
    {image ? <img src={image} alt={title} className="project-img" /> : null}
    <div className="project-content">
      <h3>{title}</h3>
      {summary ? <p>{summary}</p> : null}
      {link ? (
        <a href={link} className="project-link" target="_blank" rel="noreferrer">
          Visit Resource
        </a>
      ) : null}
    </div>
  </div>
);
